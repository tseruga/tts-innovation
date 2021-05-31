color_codes = {
  Blue = {0, 0, 1},
  Red = {1, 0, 0},
  Green = {0, 0.7, 0},
  Purple = {0.7, 0, 0.7},
  Yellow = {0.5, 0.5, 0}
}

states = {
  "Not Splayed",
  "Splayed Left",
  "Splayed Right",
  "Splayed Up"
}

current_state_idx = 0
current_color = ""

function set_color(p)
  params = {
      click_function = "click_func",
      function_owner = self,
      label          = "",
      position       = {0, 1, 0},
      rotation       = {0, 90, 0},
      width          = 1500,
      height         = 1000,
      font_size      = 250,
      color          = {0.5, 0.5, 0.5},
      font_color     = {1, 1, 1},
  }
  self.createButton(params)

  params = {
      click_function = "cycle_right",
      function_owner = self,
      label          = ">",
      position       = {0, 1, 2},
      rotation       = {0, 90, 0},
      width          = 400,
      height         = 400,
      font_size      = 340,
      color          = {0.5, 0.5, 0.5},
      font_color     = {1, 1, 1},
  }
  self.createButton(params)

  params = {
      click_function = "cycle_left",
      function_owner = self,
      label          = "<",
      position       = {0, 1, -2},
      rotation       = {0, 90, 0},
      width          = 400,
      height         = 400,
      font_size      = 340,
      color          = {0.5, 0.5, 0.5},
      font_color     = {1, 1, 1},
  }
  self.createButton(params)

  current_color = p.color
  self.editButton({
    index = 0,
    color = color_codes[p.color],
    label = p.color.."\n"..states[1]
  })
end

function cycle_right()
  current_state_idx = (current_state_idx + 1) % #states
  self.editButton({
    index = 0,
    label = current_color.."\n"..states[current_state_idx + 1]
  })
end

function cycle_left()
  current_state_idx = (current_state_idx -1) % #states
  self.editButton({
    index = 0,
    label = current_color.."\n"..states[current_state_idx + 1]
  })
end

function get_state()
  state_text = states[current_state_idx + 1]
  if string.find(state_text, "Not") then
    return "None"
  elseif string.find(state_text, "Left") then
    return "Left"
  elseif string.find(state_text, "Right") then
    return "Right"
  elseif string.find(state_text, "Up") then
    return "Up"
  end
end

function click_func(obj, color, alt_click)
  return
end
