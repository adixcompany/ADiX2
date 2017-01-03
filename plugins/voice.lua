local function urlencode(str)
  str = string.gsub (str, "\n", "\r\n")
  str = string.gsub (str, "([^%w ])",
  function (c) return string.format ("%%%02X", string.byte(c)) end)
    str = string.gsub (str, " ", "+")
    return str
  end
  local function run(msg, matches)
    if string.len(matches[2]) > 20 and not is_sudo(msg) then
      return reply_msg(msg.id, "حداکثر 20 کاراکتر", ok_cb, false)
    end

    if redis:get("voice:"..msg.to.id..":"..msg.from.id) and not is_sudo(msg) then
      return reply_msg(msg.id, "Error!Bot have a problem!Please wait to reboot bot.Error code: XH1", ok_cb, false)
    end
    redis:setex("voice:"..msg.to.id..":"..msg.from.id, 60, true)
    local text = matches[2]
    local ent = urlencode(text)
    local url = "http://api.farsireader.com/ArianaCloudService/ReadTextGET?APIKey=MQO0SC5GWITCRKR&Text="..ent.."&Speaker=Female1&Format=mp3%2F32%2Fm&GainLevel=0&PitchLevel=0&PunctuationLevel=0&SpeechSpeedLevel=0&ToneLevel=0"
    local file = download_to_file(url, 'voice.ogg')
    send_audio(get_receiver(msg), file, ok_cb, false)
  end

  return {
    patterns = {
      "^([Vv][Oo][Ii][Cc][Ee]) +(.*)$",
    },
    run = run
  }
