function HeadshotSuccessful(victim, attackPos)
    local headShotLevel = .85

    -- Bounding-box approach from Ranged Headshot mod by SkyHasCats
    -- https://modding-openmw.gitlab.io/ranged-headshot/
    local bbox = victim:getBoundingBox()
    local half = bbox.halfSize
    local center = bbox.center

    local rel = attackPos - center
    local normalizedHeight = (rel.z + half.z) / (2 * half.z)

    return normalizedHeight > headShotLevel
end