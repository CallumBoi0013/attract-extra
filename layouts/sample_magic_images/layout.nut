fe.do_nut("magic-images.nut")

fe.add_text( "[Title]", 0, 0, fe.layout.width, 30 )
fe.add_text( "[Players]", 0, 30, fe.layout.width, 30 )
fe.add_text( "[Category]", 0, 60, fe.layout.width, 30 )
fe.add_text( "[Tags]", 0, 90, fe.layout.width, 30 )
fe.add_text( "[DisplayName]", 0, 120, fe.layout.width, 30 )

local playerImage = fe.add_image("[!players_image]", 50, 175, 100, 100)
local genreImage = fe.add_image("[!genre_image]", 175, 175, 100, 100)
local regionImage = fe.add_image("[!region_image]", 300, 175, 100, 100)
local esrbImage = fe.add_image("[!esrb_image]", 425, 175, 100, 100)
local systemImage = fe.add_image("[!system_image]", 550, 175, 100, 100)
playerImage.preserve_aspect_ratio = genreImage.preserve_aspect_ratio = regionImage.preserve_aspect_ratio = esrbImage.preserve_aspect_ratio = systemImage.preserve_aspect_ratio = true
