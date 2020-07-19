function draw()
    imgui.Begin("Align")

    state.IsWindowHovered = imgui.IsWindowHovered()

    local timingpoint = state.CurrentTimingPoint
    local starttime = timingpoint.StartTime
    local length = map.GetTimingPointLength(timingpoint)
    local endtime = starttime + length
    local signature = timingpoint.Signature
    local bpm = timingpoint.Bpm
    local mspb = 60000/bpm
    local msptl = mspb * 4

    if imgui.Button("Align Timing Points with Notes") then
        local times = {}
        local timingpoints = {}
        for time=starttime,endtime,msptl do
            table.insert(times, math.floor(time))
        end
        for _,time in pairs(times) do
            table.insert(timingpoints, utils.CreateTimingPoint(time,bpm,signature))
        end
        actions.RemoveTimingPoint(timingpoint)
        actions.PlaceTimingPointBatch(timingpoints)
    end

    --thie following doesn't work due to utils.CreateHitObject automatically truncating the time to a whole millisecond
    --[[if imgui.Button("Align Notes with Timing Points") then
        local times = {}
        local all_notes = map.HitObjects
        local old_notes = {}
        local new_notes = {}
        for time=starttime,endtime,msptl do
            times[math.floor(time)] = time
        end
        for _,note in pairs(all_notes) do
            for old_time,new_time in pairs(times) do
                if note.StartTime == old_time then
                    table.insert(old_notes, note)
                    table.insert(new_notes, utils.CreateHitObject(times[old_time],note.Lane,note.EndTime,note.HitSound))
                end
                if note.EndTime == old_time then
                    table.insert(old_notes, note)
                    table.insert(new_notes, utils.CreateHitObject(note.StartTime,note.Lane,times[old_time],note.HitSound))
                end
            end
        end
        actions.RemoveHitObjectBatch(old_notes)
        actions.PlaceHitObjectBatch(new_notes)
    end]]--

    imgui.Text("StartTime: " .. starttime)
    imgui.Text("EndTime: " .. endtime)
    imgui.Text("BPM: " .. bpm)
    imgui.Text("Length: " .. length)
    imgui.Text("MsPB: " .. mspb)
    imgui.Text("MsPTL: " .. msptl)

    imgui.End()
end
