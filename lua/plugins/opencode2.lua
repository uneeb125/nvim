return {
    "nickjvandyke/opencode.nvim",
    version = "*",
    dependencies = {
        {
            "folke/snacks.nvim",
            optional = true,
            opts = {
                input = {},
                picker = {
                    actions = {
                        opencode_send = function(...)
                            return require("opencode").snacks_picker_send(...)
                        end,
                    },
                    win = {
                        input = {
                            keys = {
                                ["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
                            },
                        },
                    },
                },
            },
        },
    },
    config = function()
        vim.o.autoread = true
        vim.o.diffopt = "internal,filler,closeoff,linematch:60,algorithm:histogram"

        vim.keymap.set({ "n", "x" }, "<leader>og", function()
            require("opencode").toggle()
        end, { desc = "Toggle opencode" })

        vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Go to code window" })
        vim.keymap.set("t", "<C-l>", "<C-\\><C-n>", { desc = "Terminal to normal mode" })

        vim.keymap.set({ "n", "x" }, "<leader>oi", function()
            require("opencode").ask("@this: ")
        end, { desc = "Ask opencode" })

        vim.keymap.set("v", "<leader>oy", function()
            require("opencode").ask("@this: ", { submit = true })
        end, { desc = "Ask with visual selection" })

        vim.keymap.set({ "n", "x" }, "<leader>o/", function()
            require("opencode").select()
        end, { desc = "Select opencode action" })

        vim.keymap.set({ "n", "x" }, "<leader>gl", function()
            return require("opencode").operator("@this ")
        end, { desc = "Add range to opencode", expr = true })

        vim.keymap.set("n", "<S-C-u>", function()
            require("opencode").command("session.half.page.up")
        end, { desc = "Scroll opencode up" })

        vim.keymap.set("n", "<S-C-d>", function()
            require("opencode").command("session.half.page.down")
        end, { desc = "Scroll opencode down" })

        vim.keymap.set("n", "+", "<C-a>", { desc = "Increment under cursor", noremap = true })
        vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement under cursor", noremap = true })

        local opencode_edits = {}
        local opencode_pending_edits = {}
        local opencode_current_session_id = nil
        local opencode_history_dir = vim.fn.stdpath("data") .. "/opencode/history"

        local function opencode_get_history_file(session_id)
            return opencode_history_dir .. "/" .. session_id .. ".json"
        end

        local function opencode_load_edits(session_id)
            local file = opencode_get_history_file(session_id)
            if vim.fn.filereadable(file) == 0 then
                return {}
            end
            local content = vim.fn.readfile(file)
            if #content > 0 then
                local ok, edits = pcall(vim.json.decode, table.concat(content, "\n"))
                if ok and type(edits) == "table" then
                    return edits
                end
            end
            return {}
        end

        local function opencode_save_edits(session_id, edits)
            vim.fn.mkdir(opencode_history_dir, "p")
            local file = opencode_get_history_file(session_id)
            vim.fn.writefile({ vim.json.encode(edits) }, file)
        end

        local function opencode_apply_session(session_id)
            vim.notify("Sync session: current=" .. (opencode_current_session_id or "nil") .. " new=" .. session_id, vim.log.levels.DEBUG)
            if session_id ~= opencode_current_session_id then
                if opencode_current_session_id then
                    opencode_save_edits(opencode_current_session_id, opencode_edits)
                end
                opencode_current_session_id = session_id
                opencode_edits = opencode_load_edits(session_id)
                vim.notify("Switched to session: " .. session_id .. " (" .. #opencode_edits .. " edits)", vim.log.levels.INFO)
            end
        end

        local function opencode_sync_session()
            if opencode_current_session_id then
                return
            end
            require("opencode.server").get(false):next(function(server)
                server:get_sessions_status(function(statuses)
                    local active_session_id = nil
                    if statuses then
                        for _, status in ipairs(statuses) do
                            if status.status and (status.status.type == "idle" or status.status.type == "busy") then
                                active_session_id = status.sessionID
                                break
                            end
                        end
                    end
                    if active_session_id then
                        opencode_apply_session(active_session_id)
                    end
                end)
            end):catch(function(err)
                vim.notify("Sync session failed: " .. err, vim.log.levels.DEBUG)
            end)
        end

        vim.api.nvim_create_autocmd("User", {
            pattern = "OpencodeEvent:*",
            callback = function(args)
                local event = args.data.event
                if not opencode_current_session_id then
                    opencode_sync_session()
                end
                if event.type == "session.idle" then
                    vim.notify("opencode finished responding", vim.log.levels.INFO)
                elseif event.type == "session.status" or event.type == "message.updated" then
                    local session_id = event.properties and event.properties.sessionID or event.sessionID
                    if session_id and session_id ~= opencode_current_session_id then
                        if opencode_current_session_id then
                            opencode_save_edits(opencode_current_session_id, opencode_edits)
                        end
                        opencode_current_session_id = session_id
                        opencode_edits = opencode_load_edits(session_id)
                        vim.notify("Switched to opencode session: " .. session_id .. " (" .. #opencode_edits .. " edits)", vim.log.levels.INFO)
                    end
                elseif event.type == "message.part.updated" then
                    local props = event.properties
                    if props.part and props.part.type == "tool" then
                        local tool_name = props.part.tool
                        local state = props.part.state
                        local part_id = props.part.id
                        if state and state.input then
                            local input = state.input
                            local filepath = input.filePath or input.file or input.path or input.command
                            if filepath and (tool_name == "edit" or tool_name == "write") then
                                if not opencode_pending_edits[part_id] then
                                    local line = nil
                                    if tool_name == "edit" then
                                        vim.defer_fn(function()
                                            vim.cmd("checktime " .. filepath)
                                            local file_content = vim.fn.system({"cat", filepath})
                                            local file_lines = vim.split(file_content, "\n")
                                            local search_str = input.newString or input.oldString
                                            if search_str then
                                                for i, l in ipairs(file_lines) do
                                                    if l:find(search_str, 1, true) then
                                                        line = i
                                                        break
                                                    end
                                                end
                                                if not line and input.oldString and input.oldString ~= search_str then
                                                    for i, l in ipairs(file_lines) do
                                                        if l:find(input.oldString, 1, true) then
                                                            line = i
                                                            break
                                                        end
                                                    end
                                                end
                                            end
                                            opencode_pending_edits[part_id] = {
                                                tool = tool_name,
                                                file = filepath,
                                                line = line,
                                                input = input,
                                            }
                                        end, 100)
                                    else
                                        opencode_pending_edits[part_id] = {
                                            tool = tool_name,
                                            file = filepath,
                                            line = nil,
                                            input = input,
                                        }
                                    end
                                end
                                if state.status == "completed" then
                                    local pending = opencode_pending_edits[part_id]
                                    if pending then
                                        local diff = nil
                                        if tool_name == "edit" and input.oldString and input.newString then
                                            diff = "--- a/" .. filepath .. "\n+++ b/" .. filepath .. "\n@@ -1 +1 @@\n-" .. input.oldString .. "\n+" .. input.newString
                                        elseif tool_name == "write" then
                                            diff = input.content
                                        end
                                        table.insert(opencode_edits, 1, {
                                            tool = tool_name,
                                            file = filepath,
                                            line = pending.line,
                                            diff = diff,
                                            timestamp = vim.uv.now(),
                                        })
                                        if opencode_current_session_id then
                                            opencode_save_edits(opencode_current_session_id, opencode_edits)
                                        end
                                        vim.notify("Recorded opencode edit: " .. tool_name .. " " .. filepath .. (pending.line and ":" .. pending.line or ""), vim.log.levels.INFO)
                                        opencode_pending_edits[part_id] = nil
                                    end
                                end
                            end
                        end
                    end
                end
            end,
        })

        vim.keymap.set("n", "<leader>oe", function()
            opencode_sync_session()
            vim.schedule(function()
                if #opencode_edits == 0 then
                    vim.notify("No opencode edits recorded", vim.log.levels.INFO)
                    return
                end
                local items = vim.tbl_map(function(edit, idx)
                    local line_str = edit.line and ":" .. edit.line or ""
                    return {
                        idx = idx,
                        text = string.format("[%s] %s%s: %s", edit.tool, edit.file, line_str, edit.diff and "(diff)" or "(no diff)"),
                        edit = edit,
                    }
                end, opencode_edits)

                local function open_edit(edit, use_tab)
                    local line = edit.line or 1
                    local cmd = use_tab and "tabnew" or "new"
                    vim.cmd(cmd .. " +" .. line .. " " .. edit.file)
                    if edit.diff then
                        local patch_file = vim.fn.tempname() .. ".patch"
                        vim.fn.writefile(vim.split(edit.diff, "\n"), patch_file)
                        vim.cmd("silent! vert diffpatch " .. patch_file)
                    end
                end

                require("snacks.picker").pick({
                    title = "Opencode Edits",
                    items = items,
                    format = function(item)
                        return { { item.text } }
                    end,
                    confirm = function(picker, item)
                        open_edit(item.edit, false)
                        picker:close()
                    end,
                    keys = {
                        ["<S-CR>"] = {
                            function(picker, item)
                                open_edit(item.edit, true)
                                picker:close()
                            end,
                            desc = "Open in tab",
                        },
                    },
                })
            end)
        end, { desc = "Review opencode edits" })

        local opencode_edit_request_id = nil

        vim.api.nvim_create_autocmd("User", {
            pattern = "OpencodeEvent:permission.asked",
            callback = function(args)
                local event = args.data.event
                if event.properties.permission == "edit" then
                    opencode_edit_request_id = event.properties.id
                end
            end,
        })

        local function opencode_permit(reply)
            if not opencode_edit_request_id then
                vim.notify("No active opencode edit request", vim.log.levels.WARN)
                return
            end
            local port = require("opencode.events").connected_server and require("opencode.events").connected_server.port or nil
            if not port then
                vim.notify("No connected opencode server", vim.log.levels.ERROR)
                return
            end
            require("opencode.server").new(port):next(function(s)
                s:permit(opencode_edit_request_id, reply)
                opencode_edit_request_id = nil
            end)
        end

        vim.keymap.set("n", "<leader>oa", function()
            opencode_permit("once")
        end, { desc = "Accept opencode edit" })

        vim.keymap.set("n", "<leader>or", function()
            opencode_permit("reject")
        end, { desc = "Reject opencode edit" })

        vim.keymap.set("n", "<leader>o]", "]c", { desc = "Next change", remap = true })
        vim.keymap.set("n", "<leader>o[", "[c", { desc = "Prev change", remap = true })

        vim.keymap.set("n", "<leader>op", function()
            vim.cmd("normal! dp")
            opencode_permit("reject")
        end, { desc = "Accept hunk and reject edit" })

        vim.keymap.set("n", "<leader>oo", function()
            vim.cmd("normal! do")
            opencode_permit("reject")
        end, { desc = "Reject hunk and reject edit" })

        vim.keymap.set("n", "<leader>oq", function()
            vim.cmd("tabclose")
        end, { desc = "Close diff" })
    end,
}
