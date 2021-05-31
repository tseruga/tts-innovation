game_setup = false

deck_zones = {}
deck_zones[1] = "ee7a48"
deck_zones[2] = "dccdd3"
deck_zones[3] = "4536b8"
deck_zones[4] = "f7f83f"
deck_zones[5] = "1d592a"
deck_zones[6] = "279e05"
deck_zones[7] = "f74544"
deck_zones[8] = "960036"
deck_zones[9] = "56e15a"
deck_zones[10] = "4e5788"

resources = {}
resources["E"] = "Environment"
resources["K"] = "Knowledge"
resources["C"] = "Castle"
resources["M"] = "Money"
resources["I"] = "Industry"
resources["T"] = "Technology"

card_colors = {
  "Blue",
  "Yellow",
  "Purple",
  "Red",
  "Green"
}

color_lookup = {
  B = "Blue",
  Y = "Yellow",
  P = "Purple",
  R = "Red",
  G = "Green"
}

zone_zones = {
  White = "42c27c",
  Red = "f12279",
  Blue = "948312",
  Green = "70f7c2"
}

splay_indicators = {
  White = {
    Blue = "d2d401",
    Yellow = "09392a",
    Purple = "7a701a",
    Red = "d6d424",
    Green = "9fdd12"
  },
  Red = {
    Blue = "637d67",
    Yellow = "2ad1a3",
    Purple = "0a6804",
    Red = "d2b0b6",
    Green = "03cd9e"
  },
  Blue = {
    Blue = "c6247e",
    Yellow = "2ef8b0",
    Purple = "f625a3",
    Red = "87e6ac",
    Green = "a0d513"
  },
  Green = {
    Blue = "ddde9f",
    Yellow = "e8f5ea",
    Purple = "ca1584",
    Red = "dfa88e",
    Green = "e67ad4"
  }
}

resource_indicators = {
  White = {
    Environment = "717269",
    Knowledge = "c2938a",
    Castle = "45f65e",
    Money = "a29160",
    Industry = "ad8648",
    Technology = "12674c"
  },
  Red = {
    Environment = "e2940b",
    Knowledge = "177d4a",
    Castle = "9c9b0e",
    Money = "619485",
    Industry = "bce9b4",
    Technology = "0cfe3b"
  },
  Blue = {
    Environment = "bcb168",
    Knowledge = "8a6097",
    Castle = "03ce97",
    Money = "5aec71",
    Industry = "b4c3b4",
    Technology = "ceef0e"
  },
  Green = {
    Environment = "e88e5a",
    Knowledge = "47c9f7",
    Castle = "aef8d1",
    Money = "28e199",
    Industry = "104356",
    Technology = "93da8d"
  }
}

setup_button = {}
setup_button.click_function = "setup"
setup_button.label = "Setup"
setup_button.guid = "a9a05d"
setup_button.function_owner = nil
setup_button.width = 500
setup_button.height = 500
setup_button.font_size = 100
setup_button.position = {0, 0.8, 0}
setup_button.rotation = {0, 0, 0}


function onUpdate()
  if game_setup == true then
    players = getSeatedPlayers()
    for i, color in pairs(players) do
      getResourceCount(color)
    end
  end
end


function onLoad()
  setup_button_obj = getObjectFromGUID(setup_button.guid)

  if setup_button_obj ~= nil then
    setup_button_obj.createButton(setup_button)
  else
    game_setup = true
    createSplayButtons()
    createResourceButtons()
    broadcastToAll("Game reloaded. Splay states have been reset.",  {0.7,0.7,0})
  end

  for i = 1, 10 do
    deck = getDeck(i)
    deck.setVar("age", i)
  end
end


function createSplayButtons()
  players = getSeatedPlayers()
  for i, player_color in pairs(players) do
    for j, card_color in pairs(card_colors) do
      getObjectFromGUID(splay_indicators[player_color][card_color]).call("set_color", {
        color=card_color
      })
    end
  end
end

function createResourceButtons()
  players = getSeatedPlayers()
  for i, player_color in pairs(players) do
    for j, resource in pairs(resources) do
      score_button = {}
      score_button.click_function = "noop"
      score_button.label = "0"
      score_button.function_owner = nil
      score_button.width = 1250
      score_button.height = 1250
      score_button.font_size = 2500
      score_button.position = {0, 0, -3.2}
      score_button.rotation = {0, 0, 0}
      getObjectFromGUID(resource_indicators[player_color][resource]).createButton(score_button)
    end
  end
end

function noop()
  return
end


function setup()
  game_setup = true
  createSplayButtons()
  createResourceButtons()

  for i = 1, 10 do
    deck = getDeck(i)
    deck.shuffle()
  end

  for i = 1, 9 do
    getDeck(i).takeObject({
      position = {-40.3, 0, -13.5 + (3*i)},
      rotation = {180, 180, 0}
    })
  end

  players = getSeatedPlayers()
  deck1 = getDeck(1)
  for i,v in pairs(players) do
    deck1.deal(2, v)
  end

  getObjectFromGUID(setup_button.guid).destruct()

end


function getDeck(age)
  return getObjectFromGUID(deck_zones[age]).getObjects()[1]
end

function getCardAge(obj)
  return string.sub(obj.getDescription(), 1, 1)
end

function getCardColorFromCard(obj)
  return color_lookup[string.sub(obj.getDescription(), 6, 6)]
end

function getCardColorFromDeck(obj)
  return color_lookup[string.sub(obj.description, 6, 6)]
end


function getCardsResourcesFromDeck(obj)
  return string.sub(obj.description, 2, 5)
end

function getCardsResourcesFromCard(obj)
  return string.sub(obj.getDescription(), 2, 5)
end


function getResourceCount(player)
  sorted_cards = {
    Blue = {},
    Yellow = {},
    Purple = {},
    Red = {},
    Green = {}
  }

  zone = getObjectFromGUID(zone_zones[player])
  cards = zone.getObjects()
  for i, card in pairs(cards) do
    if card.tag == "Deck" then
      cards_in_deck = card.getObjects()
      for j = 1, #cards_in_deck do
        table.insert(sorted_cards[getCardColorFromDeck(cards_in_deck[j])], {
          resources = getCardsResourcesFromDeck(cards_in_deck[j]),
          position = {x=0, y=0, z=0}
        })
      end
    elseif card.tag == "Card" then
      table.insert(sorted_cards[getCardColorFromCard(card)], {
          resources = getCardsResourcesFromCard(card),
          position = card.getPosition()
      })
    end
  end

  calculateResourcesFromCardList(sorted_cards, player)

end


function calculateResourcesFromCardList(list, player)

  r_concat = ""
  for i, color in pairs(card_colors) do
    r = ""

    cards = list[color]
    if #cards ~= 0 then
      top_card = cards[#cards]
      splay_state = getObjectFromGUID(splay_indicators[player][color]).call("get_state")

      if splay_state == "None" then
        r = r..top_card.resources
      elseif splay_state == "Left" then
        top_card = getLeftmostCard(cards, player, false)
        for j, card in pairs(cards) do
          r = r..getRightResources(card)
        end
        r = r..getInverseRightResources(top_card)
      elseif splay_state == "Right" then
        top_card = getRightmostCard(cards, player, false)
        for j, card in pairs(cards) do
          r = r..getLeftResources(card)
        end
        r = r..getInverseLeftResources(top_card)
      elseif splay_state == "Up" then
        top_card = getUpmostCard(cards, player, false)
        for j, card in pairs(cards) do
          r = r..getBottomResources(card)
        end
        r = r..getInverseBottomResources(top_card)
      end

      r_concat = r_concat..r
    end
  end
  updateResourceLabels(r_concat, player)

end


function updateResourceLabels(r, player)
  for resource_shorthand, v in pairs(resources) do
    _, count = string.gsub(r, resource_shorthand, resource_shorthand)
    indicator = getObjectFromGUID(resource_indicators[player][resources[resource_shorthand]]).editButton({
      index=0,
      label=count
    })
  end
end


function getLeftmostCard(cards, player, redirected)
  if (player == "Blue" or player == "Green") and redirected == false then
    return getRightmostCard(cards, player, true)
  end

  leftmost = nil
  min_x = 10000
  for i, card in pairs(cards) do
    if card.position.x < min_x then
      min_x = card.position.x
      leftmost = card
    end
  end
  return leftmost
end


function getRightmostCard(cards, player, redirected)
  if (player == "Blue" or player == "Green") and redirected == false then
    return getLeftmostCard(cards, player, true)
  end

  rightmost = nil
  max_x = -10000
  for i, card in pairs(cards) do
    if card.position.x > max_x then
      max_x = card.position.x
      rightmost = card
    end
  end
  return rightmost
end


function getUpmostCard(cards, player, redirected)
  if (player == "Blue" or player == "Green") and redirected == false then
    return getDownmostCard(cards, player, true)
  end

  upmost = nil
  max_z = -10000
  for i, card in pairs(cards) do
    if card.position.z > max_z then
      max_z = card.position.z
      upmost = card
    end
  end
  return upmost
end

function getDownmostCard(cards, player, redirected)
  downmost = nil
  min_z = 10000
  for i, card in pairs(cards) do
    if card.position.z < min_z then
      min_z = card.position.z
      downmost = card
    end
  end
  return downmost
end


function getLeftResources(card)
  return string.sub(card.resources, 1, 2)
end

function getRightResources(card)
  return string.sub(card.resources, 4, 4)
end

function getBottomResources(card)
  return string.sub(card.resources, 2, 4)
end

function getInverseRightResources(card)
  return string.sub(card.resources, 1, 3)
end

function getInverseLeftResources(card)
  return string.sub(card.resources, 3, 4)
end

function getInverseBottomResources(card)
  return string.sub(card.resources, 1, 1)
end