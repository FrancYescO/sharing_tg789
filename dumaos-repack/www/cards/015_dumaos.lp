<%
-- Enable localization
gettext.textdomain('webui-dumaos')

local ui_helper = require("web.ui_helper")
local content_helper = require("web.content_helper")

local content_dumaos = {
  status = "rpc.dumaos.status"
}

content_helper.getExactContent(content_dumaos)

local running = (content_dumaos["status"] == '1')
local switchtext = running and T"DumaOS running" or T"DumaOS stopped"
local dumaosUrl = "http://" .. (ngx.var.host or "") .. ":81/"
%>

<div class="span3">
  <div class="smallcard">
    <%= ui_helper.createCardHeader(T"DumaOS", nil) %>
    <div class="content card_bg" data-bg-text="&#xf201;">
      <div class="divtable">
        <%
          ngx.print(
            ui_helper.createSimpleLight(running and "1" or "0", switchtext),
            '<p class="subinfos"><a href="', dumaosUrl, '" target="_blank" rel="noopener">',
            T"Open interface",
            '</a></p>'
          )
        %>
      </div>
    </div>
  </div>
</div>
