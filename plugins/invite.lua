do
local function callbackres(extra, success, result)
--vardump(result)
  local user = 'user#id'..result.peer_id
	local chat = 'chat#id'..extra.chatid
	local channel = 'channel#id'..extra.chatid
	if is_banned(result.id, extra.chatid) then 
        send_large_msg(chat, 'کاربر بن هست!برای خارج کردن او کاتالوگ را با دستور /help بخوانید')
        send_large_msg(channel, 'کاربر بن هست!برای خارج کردن او کاتالوگ را با دستور /help بخوانید')
	elseif is_gbanned(result.id) then
	    send_large_msg(chat, 'کاربر بن هست!برای خارج کردن او کاتالوگ را با دستور /help بخوانید(Globaly Mode)')
		send_large_msg(channel, 'کاربر بن هست!برای خارج کردن او کاتالوگ را با دستور /help بخوانید(Globaly Mode)')
	else    
	    chat_add_user(chat, user, ok_cb, false) 
		channel_invite(channel, user, ok_cb, false)
	end
end
function run(msg, matches)
  local data = load_data(_config.moderation.data)
  if not is_momod(msg) then
	return
  end
  if not is_admin1(msg) then -- For admins only !
		return 'Error!You are not a allowed user.Please see bot catalog with /help !Error code: XM1'
  end
  if not is_realm(msg) then
    if data[tostring(msg.to.id)]['settings']['lock_member'] == 'yes' and not is_admin1(msg) then
		  return 'گروه شخصی است'
    end
  end
	if msg.to.type ~= 'chat' or msg.to.type ~= 'channel' then 
		local cbres_extra = {chatid = msg.to.id}
		local username = matches[1]
		local username = username:gsub("@","")
		resolve_username(username,  callbackres, cbres_extra)
	end
end
return {
    patterns = {
      "^[#!/]invite (.*)$"
    },
    run = run
}

end
