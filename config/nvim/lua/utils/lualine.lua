local M = {}
M.env_cleanup = function(venv)
  if string.find(venv, "/") then
    local final_venv = venv
    for w in venv:gmatch("([^/]+)") do
      final_venv = w
    end
    venv = final_venv
  end
  return venv
end

local copilot_status = function()
  local status_c, client = pcall(require, "copilot.client")
  local status_a, api = pcall(require, "copilot.api")
  if not status_c or not status_a then
    return "unknown"
  end

  if client.is_disabled() then
    return "disabled"
  end

  local is_buf_attached = client.buf_is_attached(vim.api.nvim_get_current_buf())
  if is_buf_attached then
    local status, data = pcall(api.status)
    if status and data.status == "warning" then
      return "warning"
    elseif status and data.status == "ok" then
      return "enabled"
    else
      return "sleep"
    end
  end

  return "unknown"
end
M.copilot_status_icon = function()
  local icons = {
    enabled = " ",
    sleep = " ",
    disabled = " ",
    warning = " ",
    unknown = " ",
  }

  return icons[copilot_status()] or icons.unknown
end

M.components = {
  spaces = {
    function()
      return " "
    end,
    padding = 0.3,
  },

  mcphub = {
    function()
      -- Check if MCPHub is loaded
      if not vim.g.loaded_mcphub then
        return "󰐻 -"
      end

      local count = vim.g.mcphub_servers_count or 0
      local status = vim.g.mcphub_status or "stopped"
      local executing = vim.g.mcphub_executing

      -- Show "-" when stopped
      if status == "stopped" then
        return "󰐻 -"
      end

      -- Show spinner when executing, starting, or restarting
      if executing or status == "starting" or status == "restarting" then
        local frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
        local frame = math.floor(vim.loop.now() / 100) % #frames + 1
        return "󰐻 " .. frames[frame]
      end

      return "󰐻 " .. count
    end,
    color = function()
      if not vim.g.loaded_mcphub then
        return { fg = "#6c7086" } -- Gray for not loaded
      end

      local status = vim.g.mcphub_status or "stopped"
      if status == "ready" or status == "restarted" then
        return { fg = "#50fa7b" } -- Green for connected
      elseif status == "starting" or status == "restarting" then
        return { fg = "#ffb86c" } -- Orange for connecting
      else
        return { fg = "#ff5555" } -- Red for error/stopped
      end
    end,

    padding = { left = 0, right = 2 },
    separator = { right = "" },
  },
}

return M
