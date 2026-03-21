return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = function(_, opts)
    local utils = require("neo-tree.utils")

    local function get_package_from_path(file_path)
      local src_index = file_path:find("/src/")
      if not src_index then
        return nil
      end
      local package_path = file_path:sub(src_index + 5)
      package_path = package_path:gsub("/[^/]+$", "")
      if package_path == "" then
        return nil
      end
      return package_path:gsub("/", ".")
    end

    local function create_java_file_with_package(state, path)
      local package_name = get_package_from_path(path)
      local class_name = vim.fn.fnamemodify(path, ":t:r")

      local content = ""
      if package_name then
        content = "package " .. package_name .. ";\n\n"
      end
      content = content .. "public class " .. class_name .. " {\n\n}\n"

      local file = io.open(path, "w")
      if file then
        file:write(content)
        file:close()
        require("neo-tree.sources.filesystem").refresh()
        vim.defer_fn(function()
          vim.cmd("edit " .. path)
        end, 50)
      end
    end

    local function create_java_node_callback(config, node, callback)
      local path = node:get_id()
      local name = vim.fn.input("Nombre de la clase Java: ", "", "file")
      if name and name ~= "" then
        if not name:match("%.java$") then
          name = name .. ".java"
        end
        local full_path = path .. "/" .. name
        create_java_file_with_package(state, full_path)
      end
    end

    opts.filesystem = opts.filesystem or {}
    opts.filesystem.commands = opts.filesystem.commands or {}

    opts.filesystem.commands.java_new_file = function(state)
      local node = state.tree:get_node()
      local path = node.type == "directory" and node:get_id() or node:get_parent_id()
      create_java_node_callback(nil, { get_id = function() return path end }, nil)
    end

    opts.window.mappings = opts.window.mappings or {}
    opts.window.mappings["J"] = {
      function(state)
        local node = state.tree:get_node()
        local path = node.type == "directory" and node:get_id() or node:get_parent_id()
        local name = vim.fn.input("Nombre de la clase Java: ", "", "file")
        if name and name ~= "" then
          if not name:match("%.java$") then
            name = name .. ".java"
          end
          local full_path = path .. "/" .. name
          create_java_file_with_package(state, full_path)
        end
      end,
      desc = "New Java Class",
    }

    return opts
  end,
}
