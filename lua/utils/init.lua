local M = {}

--- Delete the syntax matching rules for URLs/URIs if set
function M.delete_url_match()
  for _, match in ipairs(vim.fn.getmatches()) do
    if match.group == "HighlightURL" then
      vim.fn.matchdelete(match.id)
    end
  end
end

--- Add syntax matching rules for highlighting URLs/URIs
function M.set_url_match()
  M.delete_url_match()
  vim.fn.matchadd("HighlightURL", M.url_matcher, 15)
end

return M
