local animation = {}

-- setup images
function setup_image(image, path)
    if (image) then
        image:SetPath(path)
        image.visible = true
    end
end

function animation:load()
    animation.frame_1 = images:new()
    setup_image(animation.frame_1, 'frame_1.png')
    animation.frame_1.width = 52
    animation.frame_1.height = 120
    animation.frame_1.position_x = 500
    animation.frame_1.position_y = 500
    animation.frame_1.visible = true
end

function animation:reload()
    setup_image(animation.frame_1, 'frame_1.png')
    animation.frame_1.width = 52
    animation.frame_1.height = 120
    animation.frame_1.position_x = 500
    animation.frame_1.position_y = 500
    animation.frame_1.visible = true
end

function animation:update()
    animation.frame_1.visible = true
end

return animation
