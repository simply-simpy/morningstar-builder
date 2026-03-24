require "json"
require "time"

SOURCE_FILE = "Morningstar_MC6PRO_Contextual_V1_Test_20260314.json"
OUTPUT_FILE = "Morningstar_MC6PRO_Contextual_V1_Test_20260314.json"

HOME_BANK = 0
ABLETON_HOME_BANK = 1
MAIN_PEDALS_BANK = 2
SONGS_BANK = 3
ABLETON_GUITAR_BANK = 10
ABLETON_VOICE_BANK = 11
FLINT_REVERB_BANK = 50
FLINT_TREM_BANK = 51
EC1_BANK = 52
DECO_DOUBLER_BANK = 53
DELAY_MANUAL_A_BANK = 54
DELAY_MANUAL_B_BANK = 55
DECO_TAPE_BANK = 56
RC500_BANK = 57

FLINT_CHANNEL = 6
EC1_CHANNEL = 7
DECO_CHANNEL = 8
RC500_CHANNEL = 9
ABLETON_GUITAR_CHANNEL = 1
ABLETON_VOICE_CHANNEL = 2

TAP_SLOTS = [2, 8, 14, 20]
BACK_HOME_SLOTS = [5, 11, 17, 23]

PARENT_BANKS = {
  HOME_BANK => HOME_BANK,
  ABLETON_HOME_BANK => HOME_BANK,
  MAIN_PEDALS_BANK => HOME_BANK,
  SONGS_BANK => HOME_BANK,
  ABLETON_GUITAR_BANK => ABLETON_HOME_BANK,
  ABLETON_VOICE_BANK => ABLETON_HOME_BANK,
  FLINT_REVERB_BANK => MAIN_PEDALS_BANK,
  FLINT_TREM_BANK => MAIN_PEDALS_BANK,
  EC1_BANK => MAIN_PEDALS_BANK,
  DECO_DOUBLER_BANK => MAIN_PEDALS_BANK,
  DELAY_MANUAL_A_BANK => MAIN_PEDALS_BANK,
  DELAY_MANUAL_B_BANK => DELAY_MANUAL_A_BANK,
  DECO_TAPE_BANK => MAIN_PEDALS_BANK,
  RC500_BANK => HOME_BANK
}.freeze

REVERB_MEDIUM = [
  [16, 127],
  [17, 2],
  [18, 38],
  [19, 64],
  [20, 56],
  [21, 14],
  [22, 64]
].freeze

TREM_MEDIUM = [
  [10, 127],
  [11, 2],
  [12, 52],
  [15, 64]
].freeze

REVERB_LEVELS = {
  "Light" => [[16, 127], [17, 2], [18, 26], [19, 54], [20, 40], [21, 10], [22, 64]],
  "Medium" => REVERB_MEDIUM,
  "Med Heavy" => [[16, 127], [17, 2], [18, 50], [19, 70], [20, 74], [21, 22], [22, 64]],
  "Heavy" => [[16, 127], [17, 2], [18, 64], [19, 76], [20, 94], [21, 30], [22, 64]]
}.freeze

TREM_LEVELS = {
  "Light" => [[10, 127], [11, 2], [12, 28], [15, 64]],
  "Medium" => TREM_MEDIUM,
  "Med Heavy" => [[10, 127], [11, 2], [12, 78], [15, 64]],
  "Heavy" => [[10, 127], [11, 2], [12, 108], [15, 64]]
}.freeze

TREM_SUBDIVISION_SCROLL = [
  ["1/4", 127],
  ["1/8", 84],
  ["Trip", 42],
  ["1/16", 0]
].freeze

EC1_LEVELS = {
  "Light" => 1,
  "Medium" => 2,
  "Med Heavy" => 3,
  "Heavy" => 4
}.freeze

DECO_DOUBLER_LEVELS = {
  "Light" => 1,
  "Medium" => 2,
  "Med Heavy" => 3,
  "Heavy" => 4
}.freeze

DECO_TAPE_LEVELS = {
  "Light" => [[10, 127], [11, 0], [12, 28], [13, 64], [14, 72], [15, 64]],
  "Medium" => [[10, 127], [11, 0], [12, 52], [13, 68], [14, 64], [15, 64]],
  "Heavy" => [[10, 127], [11, 0], [12, 88], [13, 76], [14, 54], [15, 72]]
}.freeze

DECO_TAPE_MODE_SCROLL = [
  ["Clsc", 0],
  ["Cass", 127]
].freeze

DELAY_MANUAL_SCROLLS = {
  mix: [["Dry", 18], ["Lo", 36], ["Med", 54], ["Hi", 72], ["Wet", 88]],
  repeats: [["1", 18], ["2", 34], ["3", 52], ["4", 74], ["Long", 104]],
  tape_age: [["Fresh", 8], ["Warm", 28], ["Worn", 50], ["Old", 74], ["Dust", 100]],
  mechanics: [["Tight", 6], ["Loose", 20], ["Warp", 40], ["Wow", 64], ["Broken", 96]],
  rec_level: [["Low", 0], ["Med", 64], ["High", 127]],
  preamp: [["A", 0], ["B", 127]],
  tap_division: [["1/4", 127], ["D8", 84], ["1/8", 42], ["Trip", 0]],
  preset_scroll: (1..16).map { |num| ["P#{num}", num] }
}.freeze

REVERB_EXPRESSION = [
  [FLINT_CHANNEL, 18, 30, 96],
  [FLINT_CHANNEL, 20, 52, 120]
].freeze

TREM_EXPRESSION = [
  [FLINT_CHANNEL, 12, 32, 127],
  [FLINT_CHANNEL, 15, 64, 78]
].freeze

DELAY_EXPRESSION = [
  [EC1_CHANNEL, 16, 18, 88],
  [EC1_CHANNEL, 14, 18, 104]
].freeze

DOUBLER_EXPRESSION = [
  [DECO_CHANNEL, 18, 18, 110],
  [DECO_CHANNEL, 20, 30, 108],
  [DECO_CHANNEL, 19, 0, 72]
].freeze

TAPE_EXPRESSION = [
  [DECO_CHANNEL, 12, 20, 110],
  [DECO_CHANNEL, 14, 80, 36]
].freeze

RC500_EXPRESSION = [
  [RC500_CHANNEL, 26, 0, 127]
].freeze

OMNIPORT_TYPES = [5, 5, 5, 1].freeze
POSITION_1 = 0
POSITION_2 = 1
POSITION_BOTH = 2
LAST_USED_BANK_ONLY_IGNORE_PRESETS = 0
HOME_BANK_COLOR = 2
ABLETON_HOME_BANK_COLOR = 49
MAIN_PEDALS_BANK_COLOR = 8
SONGS_BANK_COLOR = 127
DETAIL_BANK_COLOR = 39
DEFAULT_TEXT_COLOR = 127
REVERB_BANK_COLOR = 39
TREM_BANK_COLOR = 58
DELAY_BANK_COLOR = 61
DOUBLER_BANK_COLOR = 4
RC500_BANK_COLOR = 2
REVERB_BANK_TEXT_COLOR = 0
TREM_BANK_TEXT_COLOR = 127
DELAY_BANK_TEXT_COLOR = 0
DOUBLER_BANK_TEXT_COLOR = 0
RC500_BANK_TEXT_COLOR = 127
HOME_ABLETON_BUTTON_COLOR = 49
HOME_PEDALS_BUTTON_COLOR = 8
HOME_RC500_BUTTON_COLOR = RC500_BANK_COLOR
LEVEL_BUTTON_BACKGROUNDS = {
  "Light" => 5,
  "Medium" => 44,
  "Med Heavy" => 46,
  "Heavy" => 3
}.freeze
LEVEL_BUTTON_TEXT_COLOR = 7
EFFECT_OFF_LED_COLOR = 9
EFFECT_ON_LED_COLOR = 1
TAP_BACKGROUND_COLOR = 34
TAP_TEXT_COLOR = 0
TAP_LED_COLOR = 1
BACK_BACKGROUND_COLOR = 28
BACK_TEXT_COLOR = 7
MAIN_PEDALS_BUTTON_COLORS = {
  "Reverb" => REVERB_BANK_COLOR,
  "Tremolo" => TREM_BANK_COLOR,
  "Delay" => DELAY_BANK_COLOR,
  "Doubler" => DOUBLER_BANK_COLOR
}.freeze
MAIN_PEDALS_BUTTON_TEXT_COLORS = {
  "Reverb" => 0,
  "Tremolo" => 7,
  "Delay" => 0,
  "Doubler" => 0
}.freeze
REVERB_TOGGLE_RESET_GROUP = 26
TREM_TOGGLE_RESET_GROUP = 27
DELAY_TOGGLE_RESET_GROUP = 28
DOUBLER_TOGGLE_RESET_GROUP = 29
TAPE_TOGGLE_RESET_GROUP = 30
EXPRESSION_PRESET_INDEX = 3
RELAY_PORT_A = 4
RELAY_ACTION_NOTHING = 0
RELAY_ACTION_SYNC_CLOCK_8_TAPS = 6
RC500_CC_RHYTHM_PLAY = 20
RC500_CC_RHYTHM_STOP = 21
RC500_CC_TRANSPORT_TOGGLE = 22
RC500_CC_TEMPO_DOWN = 23
RC500_CC_TEMPO_UP = 24
RC500_CC_RHYTHM_LEVEL = 26

def deep_clone(obj)
  JSON.parse(JSON.generate(obj))
end

def zero_message(index)
  {
    "data" => Array.new(18, 0),
    "m" => index,
    "c" => 1,
    "t" => 0,
    "a" => 0,
    "tg" => POSITION_BOTH,
    "mi" => ""
  }
end

def reset_preset!(preset, bank_num, preset_num)
  preset["presetNum"] = preset_num
  preset["bankNum"] = bank_num
  preset["isExp"] = false
  preset["shortName"] = "EMPTY"
  preset["toggleName"] = ""
  preset["longName"] = ""
  preset["shiftName"] = ""
  preset["toToggle"] = false
  preset["toBlink"] = false
  preset["toMsgScroll"] = false
  preset["toggleGroup"] = 0
  preset["ledColor"] = 0
  preset["ledToggleColor"] = 0
  preset["ledShiftColor"] = 0
  preset["nameColor"] = 7
  preset["nameToggleColor"] = 7
  preset["nameShiftColor"] = 7
  preset["backgroundColor"] = 0
  preset["toggleBackgroundColor"] = 0
  preset["shiftBackgroundColor"] = 0
  preset["msgArray"] = Array.new(32) { |i| zero_message(i) }
end

def reset_exp_preset!(preset, bank_num, preset_num)
  reset_preset!(preset, bank_num, preset_num)
  preset["isExp"] = true
end

def reset_bank!(bank, bank_num, bank_name)
  bank["bankNumber"] = bank_num
  bank["bankName"] = bank_name
  bank["bankClearToggle"] = false
  bank["bankMsgArray"] = Array.new(32) do |i|
    {
      "data" => [0, 0, 0, 0, 0, 0, 0, 0, 0, 127, 0, 0, 0, 0, 0, 0, 0, 0],
      "m" => i,
      "c" => 1,
      "t" => 0,
      "a" => 0,
      "tg" => 2,
      "mi" => ""
    }
  end
  bank["presetArray"].each_with_index do |preset, preset_num|
    reset_preset!(preset, bank_num, preset_num)
  end
  bank["expPresetArray"].each_with_index do |preset, preset_num|
    reset_exp_preset!(preset, bank_num, preset_num)
  end
end

def set_bank_colors!(bank, background_color, text_color: DEFAULT_TEXT_COLOR)
  bank["backgroundColor"] = background_color
  bank["textColor"] = text_color
  bank["isColorEnabled"] = true
end

def set_label!(bank, preset_num, label)
  bank["presetArray"][preset_num]["shortName"] = label
end

def set_bank_jump!(bank, preset_num, message_num, target_bank, action: 1)
  msg = bank["presetArray"][preset_num]["msgArray"][message_num]
  msg["c"] = 1
  msg["t"] = 13
  msg["a"] = action
  msg["tg"] = POSITION_BOTH
  msg["data"] = Array.new(18, 0)
  msg["data"][0] = target_bank
  msg["data"][1] = 0
  msg["data"][2] = 6
end

def set_last_used_bank_jump!(bank, preset_num, message_num, action: 2)
  msg = bank["presetArray"][preset_num]["msgArray"][message_num]
  msg["c"] = 1
  msg["t"] = 13
  msg["a"] = action
  msg["tg"] = POSITION_BOTH
  msg["data"] = Array.new(18, 0)
  msg["data"][1] = 125
  msg["data"][2] = 6
end

def set_special_home_jump!(bank, preset_num, message_num, action:)
  msg = bank["presetArray"][preset_num]["msgArray"][message_num]
  msg["c"] = 1
  msg["t"] = 13
  msg["a"] = action
  msg["tg"] = POSITION_BOTH
  msg["data"] = Array.new(18, 0)
end

def set_cc!(bank, preset_num, message_num, channel, cc, value, action: 1, position: POSITION_BOTH)
  msg = bank["presetArray"][preset_num]["msgArray"][message_num]
  msg["c"] = channel
  msg["t"] = 2
  msg["a"] = action
  msg["tg"] = position
  msg["data"] = Array.new(18, 0)
  msg["data"][0] = cc
  msg["data"][1] = value
end

def set_pc!(bank, preset_num, message_num, channel, pc, action: 1, position: POSITION_BOTH)
  msg = bank["presetArray"][preset_num]["msgArray"][message_num]
  msg["c"] = channel
  msg["t"] = 1
  msg["a"] = action
  msg["tg"] = position
  msg["data"] = Array.new(18, 0)
  msg["data"][0] = pc
end

def set_midi_clock_tap!(bank, preset_num, message_num, action: 1, position: POSITION_BOTH)
  msg = bank["presetArray"][preset_num]["msgArray"][message_num]
  msg["c"] = 1
  msg["t"] = 24
  msg["a"] = action
  msg["tg"] = position
  msg["data"] = Array.new(18, 0)
end

def set_relay_message!(bank, preset_num, message_num, relay_port, tip_action:, ring_action:, action: 1, position: POSITION_BOTH)
  msg = bank["presetArray"][preset_num]["msgArray"][message_num]
  msg["c"] = 1
  msg["t"] = 40
  msg["a"] = action
  msg["tg"] = position
  msg["data"] = Array.new(18, 0)
  msg["data"][0] = relay_port
  msg["data"][1] = tip_action
  msg["data"][2] = ring_action
end

def set_expression_cc!(bank, exp_preset_num, message_num, channel, cc, min_value, max_value)
  msg = bank["expPresetArray"][exp_preset_num]["msgArray"][message_num]
  msg["c"] = channel
  msg["t"] = 1
  msg["a"] = 0
  msg["tg"] = 0
  msg["data"] = Array.new(18, 0)
  msg["data"][0] = cc
  msg["data"][1] = min_value
  msg["data"][2] = max_value
end

def configure_expression_preset!(bank, label, assignments, exp_preset_num: EXPRESSION_PRESET_INDEX)
  preset = bank["expPresetArray"][exp_preset_num]
  reset_exp_preset!(preset, bank["bankNumber"], exp_preset_num)
  preset["shortName"] = label
  preset["nameColor"] = LEVEL_BUTTON_TEXT_COLOR
  assignments.each_with_index do |(channel, cc, min_value, max_value), message_num|
    set_expression_cc!(bank, exp_preset_num, message_num, channel, cc, min_value, max_value)
  end
end

def style_static_preset!(bank, preset_num, label, background_color:, text_color:, toggle_background_color: 0)
  preset = bank["presetArray"][preset_num]
  preset["shortName"] = label
  preset["backgroundColor"] = background_color
  preset["toggleBackgroundColor"] = toggle_background_color
  preset["nameColor"] = text_color
  preset["nameToggleColor"] = text_color
end

def style_nav_button!(bank, preset_num, label, background_color:, text_color:)
  style_static_preset!(bank, preset_num, label, background_color: background_color, text_color: text_color)
end

def style_tap_preset!(bank, preset_num)
  style_static_preset!(bank, preset_num, "Tap", background_color: TAP_BACKGROUND_COLOR, text_color: TAP_TEXT_COLOR)
  preset = bank["presetArray"][preset_num]
  preset["ledColor"] = TAP_LED_COLOR
  preset["nameToggleColor"] = TAP_TEXT_COLOR
end

def style_back_preset!(bank, preset_num)
  style_static_preset!(bank, preset_num, "\\- Back", background_color: BACK_BACKGROUND_COLOR, text_color: BACK_TEXT_COLOR)
end

def style_home_preset!(bank, preset_num)
  style_static_preset!(bank, preset_num, "Home", background_color: BACK_BACKGROUND_COLOR, text_color: BACK_TEXT_COLOR)
end

def style_rc500_test_preset!(bank, preset_num, label, background_color:)
  style_static_preset!(bank, preset_num, label, background_color: background_color, text_color: LEVEL_BUTTON_TEXT_COLOR)
  bank["presetArray"][preset_num]["ledColor"] = EFFECT_ON_LED_COLOR
end

def set_rc500_tempo_adjust_preset!(bank, preset_num, label, cc_number, background_color:)
  style_rc500_test_preset!(bank, preset_num, label, background_color: background_color)
  # Use Release for short taps and Long Press for the +5/-5 behavior so long holds
  # do not also fire the short single-step action.
  set_cc!(bank, preset_num, 0, RC500_CHANNEL, cc_number, 127, action: 2)
  5.times do |index|
    set_cc!(bank, preset_num, index + 1, RC500_CHANNEL, cc_number, 127, action: 3)
  end
end

def set_rc500_toggle_preset!(bank, preset_num, short_name, toggle_name, first_cc, second_cc, background_color:)
  preset = bank["presetArray"][preset_num]
  preset["shortName"] = short_name
  preset["toggleName"] = toggle_name
  preset["toToggle"] = true
  preset["backgroundColor"] = background_color
  preset["toggleBackgroundColor"] = background_color
  preset["nameColor"] = LEVEL_BUTTON_TEXT_COLOR
  preset["nameToggleColor"] = LEVEL_BUTTON_TEXT_COLOR
  preset["ledColor"] = EFFECT_OFF_LED_COLOR
  preset["ledToggleColor"] = EFFECT_ON_LED_COLOR

  set_cc!(bank, preset_num, 0, RC500_CHANNEL, first_cc, 127, position: POSITION_1)
  set_cc!(bank, preset_num, 1, RC500_CHANNEL, second_cc, 127, position: POSITION_2)
end

def set_toggle_cc_preset!(bank, preset_num, short_name, toggle_name, channel, cc_off, value_off, cc_on, value_on)
  preset = bank["presetArray"][preset_num]
  preset["shortName"] = short_name
  preset["toggleName"] = toggle_name
  preset["toToggle"] = true

  msg_off = preset["msgArray"][0]
  msg_off["c"] = channel
  msg_off["t"] = 2
  msg_off["a"] = 1
  msg_off["tg"] = POSITION_1
  msg_off["data"] = Array.new(18, 0)
  msg_off["data"][0] = cc_off
  msg_off["data"][1] = value_off

  msg_on = preset["msgArray"][1]
  msg_on["c"] = channel
  msg_on["t"] = 2
  msg_on["a"] = 1
  msg_on["tg"] = POSITION_2
  msg_on["data"] = Array.new(18, 0)
  msg_on["data"][0] = cc_on
  msg_on["data"][1] = value_on
end

def apply_controller_defaults!(output)
  settings = output.dig("data", "controller_settings", "data", "controller_settings", "data")
  return unless settings

  # Remember scene-button toggle states when changing banks so active colors stay meaningful.
  settings["savePresetToggle"] = true
end

def apply_omniport_defaults!(output)
  omniports = output.dig("data", "controller_settings", "data", "omniports", "data")
  return unless omniports

  OMNIPORT_TYPES.each_with_index do |type, index|
    omniports[index]["data"]["type"] = type
  end
end

def sync_bank_arrangement_names!(output)
  arrangements = output.dig("data", "controller_settings", "data", "bank_arrangement", "data")
  return unless arrangements

  arrangements.each do |entry|
    bank_num = entry.dig("data", "bankNum")
    bank = output.dig("data", "bankArray", bank_num)
    entry["data"]["bankName"] = bank ? bank["bankName"] : ""
  end
end

def apply_defaults_macro!(bank, preset_num, action: 1, include_home_jump: false, start_message_num: 0)
  message_num = start_message_num

  REVERB_MEDIUM.each do |cc, value|
    set_cc!(bank, preset_num, message_num, FLINT_CHANNEL, cc, value, action: action)
    message_num += 1
  end

  TREM_MEDIUM.each do |cc, value|
    set_cc!(bank, preset_num, message_num, FLINT_CHANNEL, cc, value, action: action)
    message_num += 1
  end

  set_pc!(bank, preset_num, message_num, EC1_CHANNEL, 2, action: action)
  message_num += 1

  if include_home_jump
    set_bank_jump!(bank, preset_num, message_num, HOME_BANK, action: action)
  end
end

def style_scene_toggle!(bank, preset_num, toggle_reset_group:)
  preset = bank["presetArray"][preset_num]
  preset["toToggle"] = true
  preset["toggleName"] = preset["shortName"]
  preset["toggleGroup"] = toggle_reset_group
  preset["backgroundColor"] = LEVEL_BUTTON_BACKGROUNDS.fetch(preset["shortName"])
  preset["toggleBackgroundColor"] = LEVEL_BUTTON_BACKGROUNDS.fetch(preset["shortName"])
  preset["nameColor"] = LEVEL_BUTTON_TEXT_COLOR
  preset["nameToggleColor"] = LEVEL_BUTTON_TEXT_COLOR
  preset["ledColor"] = EFFECT_OFF_LED_COLOR
  preset["ledToggleColor"] = EFFECT_ON_LED_COLOR
end

def style_message_scroll_preset!(bank, preset_num, label, background_color:)
  preset = bank["presetArray"][preset_num]
  preset["shortName"] = label
  preset["toMsgScroll"] = true
  preset["backgroundColor"] = background_color
  preset["nameColor"] = LEVEL_BUTTON_TEXT_COLOR
  preset["nameToggleColor"] = LEVEL_BUTTON_TEXT_COLOR
  preset["ledColor"] = EFFECT_ON_LED_COLOR
end

def set_cc_scroll_preset!(bank, preset_num, label, channel, cc, steps, background_color:)
  style_message_scroll_preset!(bank, preset_num, label, background_color: background_color)
  preset = bank["presetArray"][preset_num]
  steps.each_with_index do |(step_label, value), message_num|
    set_cc!(bank, preset_num, message_num, channel, cc, value, action: 2)
    preset["msgArray"][message_num]["mi"] = step_label
  end
end

def set_pc_scroll_preset!(bank, preset_num, label, channel, steps, background_color:)
  style_message_scroll_preset!(bank, preset_num, label, background_color: background_color)
  preset = bank["presetArray"][preset_num]
  steps.each_with_index do |(step_label, value), message_num|
    set_pc!(bank, preset_num, message_num, channel, value, action: 2)
    preset["msgArray"][message_num]["mi"] = step_label
  end
end

def set_trem_subdivision_scroll_preset!(bank, preset_num)
  preset = bank["presetArray"][preset_num]
  preset["shortName"] = "Div %G"
  preset["toMsgScroll"] = true
  preset["backgroundColor"] = LEVEL_BUTTON_BACKGROUNDS.fetch("Light")
  preset["nameColor"] = LEVEL_BUTTON_TEXT_COLOR
  preset["nameToggleColor"] = LEVEL_BUTTON_TEXT_COLOR
  preset["ledColor"] = EFFECT_ON_LED_COLOR

  TREM_SUBDIVISION_SCROLL.each_with_index do |(_, value), message_num|
    set_cc!(bank, preset_num, message_num, FLINT_CHANNEL, 14, value, action: 2)
  end
end

def set_reverb_scene_preset!(bank, preset_num, label, messages)
  set_label!(bank, preset_num, label)
  style_scene_toggle!(bank, preset_num, toggle_reset_group: REVERB_TOGGLE_RESET_GROUP)

  messages.each_with_index do |(cc, value), message_num|
    set_cc!(bank, preset_num, message_num, FLINT_CHANNEL, cc, value, position: POSITION_1)
  end

  set_cc!(bank, preset_num, messages.length, FLINT_CHANNEL, 16, 0, position: POSITION_2)
end

def set_trem_scene_preset!(bank, preset_num, label, messages)
  set_label!(bank, preset_num, label)
  style_scene_toggle!(bank, preset_num, toggle_reset_group: TREM_TOGGLE_RESET_GROUP)

  messages.each_with_index do |(cc, value), message_num|
    set_cc!(bank, preset_num, message_num, FLINT_CHANNEL, cc, value, position: POSITION_1)
  end

  set_cc!(bank, preset_num, messages.length, FLINT_CHANNEL, 10, 0, position: POSITION_2)
end

def set_delay_scene_preset!(bank, preset_num, label, pc_number)
  set_label!(bank, preset_num, label)
  style_scene_toggle!(bank, preset_num, toggle_reset_group: DELAY_TOGGLE_RESET_GROUP)

  set_pc!(bank, preset_num, 0, EC1_CHANNEL, pc_number, position: POSITION_1)
  set_cc!(bank, preset_num, 1, EC1_CHANNEL, 102, 127, position: POSITION_1)

  if label == "Light"
    set_cc!(bank, preset_num, 2, EC1_CHANNEL, 63, 0, position: POSITION_1)
    set_cc!(bank, preset_num, 3, EC1_CHANNEL, 102, 0, position: POSITION_2)
    set_cc!(bank, preset_num, 4, EC1_CHANNEL, 63, 127, position: POSITION_2)
  else
    set_cc!(bank, preset_num, 2, EC1_CHANNEL, 63, 127, position: POSITION_1)
    set_cc!(bank, preset_num, 3, EC1_CHANNEL, 102, 0, position: POSITION_2)
  end
end

def set_doubler_scene_preset!(bank, preset_num, label, pc_number)
  set_label!(bank, preset_num, label)
  style_scene_toggle!(bank, preset_num, toggle_reset_group: DOUBLER_TOGGLE_RESET_GROUP)

  set_pc!(bank, preset_num, 0, DECO_CHANNEL, pc_number, position: POSITION_1)
  # Force the overall Deco path and then the Doubletracker side on, regardless
  # of how the saved preset was stored on the pedal.
  set_cc!(bank, preset_num, 1, DECO_CHANNEL, 33, 127, position: POSITION_1)
  set_cc!(bank, preset_num, 2, DECO_CHANNEL, 16, 127, position: POSITION_1)
  set_cc!(bank, preset_num, 3, DECO_CHANNEL, 16, 0, position: POSITION_2)

  # Match the Deco footswitch hold behavior by engaging Auto-Flange while held.
  set_cc!(bank, preset_num, 4, DECO_CHANNEL, 97, 127, action: 3)
  set_cc!(bank, preset_num, 5, DECO_CHANNEL, 97, 0, action: 4)
end

def set_tape_scene_preset!(bank, preset_num, label, messages)
  set_label!(bank, preset_num, label)
  style_scene_toggle!(bank, preset_num, toggle_reset_group: TAPE_TOGGLE_RESET_GROUP)

  # Force the overall Deco path and then the Tape side on, regardless of how the
  # saved preset was stored on the pedal.
  set_cc!(bank, preset_num, 0, DECO_CHANNEL, 33, 127, position: POSITION_1)

  messages.each_with_index do |(cc, value), message_num|
    set_cc!(bank, preset_num, message_num + 1, DECO_CHANNEL, cc, value, position: POSITION_1)
  end

  set_cc!(bank, preset_num, messages.length + 1, DECO_CHANNEL, 10, 0, position: POSITION_2)
end

def set_universal_back_home_and_tap!(bank, parent_bank)
  TAP_SLOTS.each do |preset_num|
    style_tap_preset!(bank, preset_num)
    set_midi_clock_tap!(bank, preset_num, 0, action: 1)
    set_relay_message!(bank, preset_num, 1, RELAY_PORT_A, tip_action: RELAY_ACTION_SYNC_CLOCK_8_TAPS, ring_action: RELAY_ACTION_NOTHING, action: 1)
    set_cc!(bank, preset_num, 2, FLINT_CHANNEL, 93, 127, action: 1)
  end

  BACK_HOME_SLOTS.each do |preset_num|
    if bank["bankNumber"] == HOME_BANK
      style_home_preset!(bank, preset_num)
      set_bank_jump!(bank, preset_num, 0, HOME_BANK, action: 2)
      set_bank_jump!(bank, preset_num, 1, HOME_BANK, action: 3)
    else
      style_back_preset!(bank, preset_num)
      set_last_used_bank_jump!(bank, preset_num, 0, action: 2)
      set_special_home_jump!(bank, preset_num, 1, action: 3)
    end
  end
end

source = JSON.parse(File.read(SOURCE_FILE))
output = deep_clone(source)

apply_controller_defaults!(output)
apply_omniport_defaults!(output)

reset_bank!(output["data"]["bankArray"][HOME_BANK], HOME_BANK, "Home")
reset_bank!(output["data"]["bankArray"][ABLETON_HOME_BANK], ABLETON_HOME_BANK, "Ableton")
reset_bank!(output["data"]["bankArray"][MAIN_PEDALS_BANK], MAIN_PEDALS_BANK, "Pedals")
reset_bank!(output["data"]["bankArray"][SONGS_BANK], SONGS_BANK, "Songs")
reset_bank!(output["data"]["bankArray"][ABLETON_GUITAR_BANK], ABLETON_GUITAR_BANK, "Ableton Guitar")
reset_bank!(output["data"]["bankArray"][ABLETON_VOICE_BANK], ABLETON_VOICE_BANK, "Ableton Voice")
reset_bank!(output["data"]["bankArray"][FLINT_REVERB_BANK], FLINT_REVERB_BANK, "Reverb")
reset_bank!(output["data"]["bankArray"][FLINT_TREM_BANK], FLINT_TREM_BANK, "Tremolo")
reset_bank!(output["data"]["bankArray"][EC1_BANK], EC1_BANK, "Delay")
reset_bank!(output["data"]["bankArray"][DECO_DOUBLER_BANK], DECO_DOUBLER_BANK, "Doubler")
reset_bank!(output["data"]["bankArray"][DELAY_MANUAL_A_BANK], DELAY_MANUAL_A_BANK, "Delay Manual")
reset_bank!(output["data"]["bankArray"][DELAY_MANUAL_B_BANK], DELAY_MANUAL_B_BANK, "Delay More")
reset_bank!(output["data"]["bankArray"][DECO_TAPE_BANK], DECO_TAPE_BANK, "Tape")
reset_bank!(output["data"]["bankArray"][RC500_BANK], RC500_BANK, "RC500")
reset_bank!(output["data"]["bankArray"][9], 9, "")

set_bank_colors!(output["data"]["bankArray"][HOME_BANK], HOME_BANK_COLOR)
set_bank_colors!(output["data"]["bankArray"][ABLETON_HOME_BANK], ABLETON_HOME_BANK_COLOR)
set_bank_colors!(output["data"]["bankArray"][MAIN_PEDALS_BANK], MAIN_PEDALS_BANK_COLOR)
set_bank_colors!(output["data"]["bankArray"][SONGS_BANK], SONGS_BANK_COLOR)

[ABLETON_GUITAR_BANK, ABLETON_VOICE_BANK].each do |bank_num|
  set_bank_colors!(output["data"]["bankArray"][bank_num], DETAIL_BANK_COLOR)
end

set_bank_colors!(output["data"]["bankArray"][FLINT_REVERB_BANK], REVERB_BANK_COLOR, text_color: REVERB_BANK_TEXT_COLOR)
set_bank_colors!(output["data"]["bankArray"][FLINT_TREM_BANK], TREM_BANK_COLOR, text_color: TREM_BANK_TEXT_COLOR)
set_bank_colors!(output["data"]["bankArray"][EC1_BANK], DELAY_BANK_COLOR, text_color: DELAY_BANK_TEXT_COLOR)
set_bank_colors!(output["data"]["bankArray"][DECO_DOUBLER_BANK], DOUBLER_BANK_COLOR, text_color: DOUBLER_BANK_TEXT_COLOR)
set_bank_colors!(output["data"]["bankArray"][DELAY_MANUAL_A_BANK], DELAY_BANK_COLOR, text_color: DELAY_BANK_TEXT_COLOR)
set_bank_colors!(output["data"]["bankArray"][DELAY_MANUAL_B_BANK], DELAY_BANK_COLOR, text_color: DELAY_BANK_TEXT_COLOR)
set_bank_colors!(output["data"]["bankArray"][DECO_TAPE_BANK], DOUBLER_BANK_COLOR, text_color: DOUBLER_BANK_TEXT_COLOR)
set_bank_colors!(output["data"]["bankArray"][RC500_BANK], RC500_BANK_COLOR, text_color: RC500_BANK_TEXT_COLOR)

[FLINT_REVERB_BANK, FLINT_TREM_BANK, EC1_BANK, DECO_DOUBLER_BANK, DELAY_MANUAL_A_BANK, DELAY_MANUAL_B_BANK, DECO_TAPE_BANK, RC500_BANK].each do |bank_num|
  output["data"]["bankArray"][bank_num]["bankClearToggle"] = false
end

# Universal buttons across all visible banks in this test file.
[HOME_BANK, ABLETON_HOME_BANK, MAIN_PEDALS_BANK, SONGS_BANK, ABLETON_GUITAR_BANK, ABLETON_VOICE_BANK, FLINT_REVERB_BANK, FLINT_TREM_BANK, EC1_BANK, DECO_DOUBLER_BANK, DELAY_MANUAL_A_BANK, DELAY_MANUAL_B_BANK, DECO_TAPE_BANK, RC500_BANK].each do |bank_num|
  set_universal_back_home_and_tap!(output["data"]["bankArray"][bank_num], PARENT_BANKS.fetch(bank_num))
end

# Global home bank page 1
home_bank = output["data"]["bankArray"][HOME_BANK]
style_nav_button!(home_bank, 0, "Ableton", background_color: HOME_ABLETON_BUTTON_COLOR, text_color: 7)
set_bank_jump!(home_bank, 0, 0, ABLETON_HOME_BANK)

style_nav_button!(home_bank, 1, "Pedals", background_color: HOME_PEDALS_BUTTON_COLOR, text_color: 7)
set_bank_jump!(home_bank, 1, 0, MAIN_PEDALS_BANK)

set_label!(home_bank, 3, "Songs")
set_bank_jump!(home_bank, 3, 0, SONGS_BANK)

style_nav_button!(home_bank, 4, "RC500", background_color: HOME_RC500_BUTTON_COLOR, text_color: 7)
set_bank_jump!(home_bank, 4, 0, RC500_BANK)

# Ableton context bank
ableton_home_bank = output["data"]["bankArray"][ABLETON_HOME_BANK]
set_label!(ableton_home_bank, 0, "Gtr Lpr")
set_bank_jump!(ableton_home_bank, 0, 0, ABLETON_GUITAR_BANK)

set_label!(ableton_home_bank, 1, "Voice Lpr")
set_bank_jump!(ableton_home_bank, 1, 0, ABLETON_VOICE_BANK)

set_label!(ableton_home_bank, 3, "Reserved")
set_label!(ableton_home_bank, 4, "Reserved")

# Main Pedals context bank
main_pedals_bank = output["data"]["bankArray"][MAIN_PEDALS_BANK]
style_nav_button!(main_pedals_bank, 0, "Reverb", background_color: MAIN_PEDALS_BUTTON_COLORS.fetch("Reverb"), text_color: MAIN_PEDALS_BUTTON_TEXT_COLORS.fetch("Reverb"))
set_bank_jump!(main_pedals_bank, 0, 0, FLINT_REVERB_BANK)

style_nav_button!(main_pedals_bank, 1, "Tremolo", background_color: MAIN_PEDALS_BUTTON_COLORS.fetch("Tremolo"), text_color: MAIN_PEDALS_BUTTON_TEXT_COLORS.fetch("Tremolo"))
set_bank_jump!(main_pedals_bank, 1, 0, FLINT_TREM_BANK)

style_nav_button!(main_pedals_bank, 3, "Delay", background_color: MAIN_PEDALS_BUTTON_COLORS.fetch("Delay"), text_color: MAIN_PEDALS_BUTTON_TEXT_COLORS.fetch("Delay"))
set_bank_jump!(main_pedals_bank, 3, 0, EC1_BANK)
set_bank_jump!(main_pedals_bank, 3, 1, DELAY_MANUAL_A_BANK, action: 3)

style_nav_button!(main_pedals_bank, 4, "Doubler", background_color: MAIN_PEDALS_BUTTON_COLORS.fetch("Doubler"), text_color: MAIN_PEDALS_BUTTON_TEXT_COLORS.fetch("Doubler"))
set_bank_jump!(main_pedals_bank, 4, 0, DECO_DOUBLER_BANK)
set_bank_jump!(main_pedals_bank, 4, 1, DECO_TAPE_BANK, action: 3)

# Songs context bank
songs_bank = output["data"]["bankArray"][SONGS_BANK]
set_label!(songs_bank, 0, "Song 1")
set_label!(songs_bank, 1, "Song 2")
set_label!(songs_bank, 3, "Song 3")
set_label!(songs_bank, 4, "Song 4")

# Ableton Guitar bank page 1
ableton_guitar_bank = output["data"]["bankArray"][ABLETON_GUITAR_BANK]
set_label!(ableton_guitar_bank, 0, "Record")
set_cc!(ableton_guitar_bank, 0, 0, ABLETON_GUITAR_CHANNEL, 1, 127)

set_label!(ableton_guitar_bank, 1, "Stop")
set_cc!(ableton_guitar_bank, 1, 0, ABLETON_GUITAR_CHANNEL, 2, 127)

set_label!(ableton_guitar_bank, 3, "Undo/Clr")
set_cc!(ableton_guitar_bank, 3, 0, ABLETON_GUITAR_CHANNEL, 3, 127)
set_cc!(ableton_guitar_bank, 3, 1, ABLETON_GUITAR_CHANNEL, 4, 127)
set_cc!(ableton_guitar_bank, 3, 2, ABLETON_GUITAR_CHANNEL, 3, 127, action: 3)

set_toggle_cc_preset!(ableton_guitar_bank, 4, "Stop", "Play", ABLETON_GUITAR_CHANNEL, 5, 127, 6, 0)

# Ableton Voice bank page 1
ableton_voice_bank = output["data"]["bankArray"][ABLETON_VOICE_BANK]
set_label!(ableton_voice_bank, 0, "Record")
set_cc!(ableton_voice_bank, 0, 0, ABLETON_VOICE_CHANNEL, 1, 127)

set_label!(ableton_voice_bank, 1, "Stop")
set_cc!(ableton_voice_bank, 1, 0, ABLETON_VOICE_CHANNEL, 2, 127)

set_label!(ableton_voice_bank, 3, "Undo/Clr")
set_cc!(ableton_voice_bank, 3, 0, ABLETON_VOICE_CHANNEL, 3, 127)
set_cc!(ableton_voice_bank, 3, 1, ABLETON_VOICE_CHANNEL, 4, 127)
set_cc!(ableton_voice_bank, 3, 2, ABLETON_VOICE_CHANNEL, 3, 127, action: 3)

set_toggle_cc_preset!(ableton_voice_bank, 4, "Stop", "Play", ABLETON_VOICE_CHANNEL, 5, 127, 6, 0)

# Flint Reverb bank page 1
reverb_bank = output["data"]["bankArray"][FLINT_REVERB_BANK]
[0, 1, 3, 4].zip(REVERB_LEVELS.to_a).each do |preset_num, (label, messages)|
  set_reverb_scene_preset!(reverb_bank, preset_num, label, messages)
end
configure_expression_preset!(reverb_bank, "Rev Expr", REVERB_EXPRESSION)

# Flint Trem bank page 1
trem_bank = output["data"]["bankArray"][FLINT_TREM_BANK]
set_trem_subdivision_scroll_preset!(trem_bank, 0)
[1, 3, 4].zip(TREM_LEVELS.slice("Light", "Medium", "Heavy").to_a).each do |preset_num, (label, messages)|
  set_trem_scene_preset!(trem_bank, preset_num, label, messages)
end
configure_expression_preset!(trem_bank, "Trem Expr", TREM_EXPRESSION)

# Delay bank page 1
ec1_bank = output["data"]["bankArray"][EC1_BANK]
[0, 1, 3, 4].zip(EC1_LEVELS.to_a).each do |preset_num, (label, pc_number)|
  set_delay_scene_preset!(ec1_bank, preset_num, label, pc_number)
end
configure_expression_preset!(ec1_bank, "Delay Expr", DELAY_EXPRESSION)

# Doubler bank page 1
doubler_bank = output["data"]["bankArray"][DECO_DOUBLER_BANK]
[0, 1, 3, 4].zip(DECO_DOUBLER_LEVELS.to_a).each do |preset_num, (label, pc_number)|
  set_doubler_scene_preset!(doubler_bank, preset_num, label, pc_number)
end
configure_expression_preset!(doubler_bank, "Dblr Expr", DOUBLER_EXPRESSION)

# Tape bank
tape_bank = output["data"]["bankArray"][DECO_TAPE_BANK]
[0, 1, 3].zip(DECO_TAPE_LEVELS.to_a).each do |preset_num, (label, messages)|
  set_tape_scene_preset!(tape_bank, preset_num, label, messages)
end
set_cc_scroll_preset!(tape_bank, 4, "Mode %G", DECO_CHANNEL, 11, DECO_TAPE_MODE_SCROLL, background_color: LEVEL_BUTTON_BACKGROUNDS.fetch("Heavy"))
configure_expression_preset!(tape_bank, "Tape Expr", TAPE_EXPRESSION)

# RC-500 bank
rc500_bank = output["data"]["bankArray"][RC500_BANK]
set_rc500_tempo_adjust_preset!(rc500_bank, 0, "Tmp -", RC500_CC_TEMPO_DOWN, background_color: LEVEL_BUTTON_BACKGROUNDS.fetch("Light"))
set_rc500_tempo_adjust_preset!(rc500_bank, 1, "Tmp +", RC500_CC_TEMPO_UP, background_color: LEVEL_BUTTON_BACKGROUNDS.fetch("Medium"))
set_rc500_toggle_preset!(rc500_bank, 3, "Arm", "Unarm", RC500_CC_RHYTHM_PLAY, RC500_CC_RHYTHM_STOP, background_color: LEVEL_BUTTON_BACKGROUNDS.fetch("Med Heavy"))
set_rc500_toggle_preset!(rc500_bank, 4, "Start", "Stop", RC500_CC_TRANSPORT_TOGGLE, RC500_CC_TRANSPORT_TOGGLE, background_color: LEVEL_BUTTON_BACKGROUNDS.fetch("Heavy"))
configure_expression_preset!(rc500_bank, "RC500 Expr", RC500_EXPRESSION)

# Delay Manual A bank
delay_manual_a_bank = output["data"]["bankArray"][DELAY_MANUAL_A_BANK]
set_cc_scroll_preset!(delay_manual_a_bank, 0, "Mix %G", EC1_CHANNEL, 16, DELAY_MANUAL_SCROLLS[:mix], background_color: LEVEL_BUTTON_BACKGROUNDS.fetch("Light"))
set_cc_scroll_preset!(delay_manual_a_bank, 1, "Rpts %G", EC1_CHANNEL, 14, DELAY_MANUAL_SCROLLS[:repeats], background_color: LEVEL_BUTTON_BACKGROUNDS.fetch("Medium"))
set_cc_scroll_preset!(delay_manual_a_bank, 3, "Age %G", EC1_CHANNEL, 13, DELAY_MANUAL_SCROLLS[:tape_age], background_color: LEVEL_BUTTON_BACKGROUNDS.fetch("Med Heavy"))
set_cc_scroll_preset!(delay_manual_a_bank, 4, "Mech %G", EC1_CHANNEL, 15, DELAY_MANUAL_SCROLLS[:mechanics], background_color: LEVEL_BUTTON_BACKGROUNDS.fetch("Heavy"))
set_bank_jump!(delay_manual_a_bank, 4, 5, DELAY_MANUAL_B_BANK, action: 3)

# Delay Manual B bank
delay_manual_b_bank = output["data"]["bankArray"][DELAY_MANUAL_B_BANK]
set_cc_scroll_preset!(delay_manual_b_bank, 0, "Lvl %G", EC1_CHANNEL, 11, DELAY_MANUAL_SCROLLS[:rec_level], background_color: LEVEL_BUTTON_BACKGROUNDS.fetch("Light"))
set_cc_scroll_preset!(delay_manual_b_bank, 1, "Pre %G", EC1_CHANNEL, 17, DELAY_MANUAL_SCROLLS[:preamp], background_color: LEVEL_BUTTON_BACKGROUNDS.fetch("Medium"))
set_cc_scroll_preset!(delay_manual_b_bank, 3, "Div %G", EC1_CHANNEL, 18, DELAY_MANUAL_SCROLLS[:tap_division], background_color: LEVEL_BUTTON_BACKGROUNDS.fetch("Med Heavy"))
set_pc_scroll_preset!(delay_manual_b_bank, 4, "Prst %G", EC1_CHANNEL, DELAY_MANUAL_SCROLLS[:preset_scroll], background_color: LEVEL_BUTTON_BACKGROUNDS.fetch("Heavy"))

sync_bank_arrangement_names!(output)

output["downloadDate"] = Time.now.utc.iso8601
output["description"] = "Codex-generated contextual Flint + Delay + Delay Manual + Deco Tape + Doubler + RC500 layout with expression and relay tempo"
output["hash"] = rand(2**31)

File.write(OUTPUT_FILE, JSON.generate(output))
puts OUTPUT_FILE
