function add_box(x, y, w, h, text)
    local b = {
        x = x, y = y,
        w = w, h = h,
        text = text
    }
    add(boxes, b)
    return b
end

function draw_boxes()
    for b in all(boxes) do
        local x, y, w, h = b.x, b.y, b.w, b.h
        rectf(x, y, w, h, 1)
        rectf(x + 1, y + 1, w - 2, h - 2, 6)
        rectf(x + 2, y + 2, w - 4, h - 4, 1)

        x += 4
        y += 4
        clip(x, y, w - 8, h - 8)
        for i = 1, #b.text do
            local t = b.text[i]
            print(t, x, y, 6)
            y += 6
        end
    end
end