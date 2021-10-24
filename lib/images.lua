-- The below is taken from spaceblock as I didn't want to rewrite the image tinting functionality
Images={}

	
function table.HasValue(t,x) for k,v in pairs(t)do if(v==x)then return true end end return false end
function table.merge(s,t)
	for k,v in pairs(t) do
		s[k]=v
	end
	return s
end

local function istable(v) return type(v)=="table" end
local function isstring(v) return type(v)=="string" end
local function isnumber(v) return type(v)=="number" end

Images.offset_keys={"north_position","south_position","east_position","west_position","red","green","alert_icon_shift"} -- Table keys that are offsets
function Images.IsImageLayer(k,v)
	if (v.filenames) then
		for i,e in pairs(v.filenames) do
			if(e:find(".png"))
			then return true end
		end
	end
	
	return v.layers or (v.filename and v.filename:find(".png"))

end

function Images.IsOffsetLayer(k,v)
	return (istable(v) and isstring(k) and (k:find("offset") or table.HasValue(Images.offset_keys,k)))
end

function Images.IsRailLayer(k,v)
	return istable(v) and (v.metals or v.backplates)
end

function Images.LoopFindImageLayers(Imagestype,lz) 
	if(not Imagestype) then
		return
	end
	
	for key,val in pairs(Imagestype) do
		if(istable(val) and key~="sound") then
			if(Images.IsImageLayer(key,val))then
				if(val.layers) then
					for i,e in pairs(val.layers) do
						table.insert(lz.images,e)
					end
				else
					table.insert(lz.images,val)
				end
			elseif(Images.IsOffsetLayer(key,val)) then
				table.insert(lz.offsets,val)
			elseif(Images.IsRailLayer(key,val)) then
				table.insert(lz.rails,val)
			else
				Images.LoopFindImageLayers(val,lz)
			end
		end
	end
end

function Images.FindImageLayers(Imagestype)
	local imgz={images={},offsets={},rails={}}
	Images.LoopFindImageLayers(Imagestype,imgz)
	return imgz
end

function Images.MergeImageTable(img,tbl)
	if(img.hr_version) then
		Images.MergeImageTable(img.hr_version,table.deepcopy(tbl))
	end
	
	table.merge(img,table.deepcopy(tbl))
end

function Images.MultiplyOffsets(v,z) --if(v[1] and istable(v[1]) and not vector.is_zero(v[1]) and not vector.is_zero(v[2]))then
	for a,b in pairs(v) do
		if(istable(b)) then
			for c,d in pairs(b) do
				v[a][c]=d*z
			end
		else
			v[a]=b*z
		end
	end --else vector.set(v,vector(v)*z) --v[1]=v[1]*z v[2]=v[2]*z
end --end

function Images.MultiplyImageSize(img,z) 
	if(img.hr_version) then
		Images.MultiplyImageSize(img.hr_version,z)
	end
	
	if(img.shift and istable(img.shift)) then
		for i,e in pairs(img.shift) do
			if(istable(e)) then
				for a,b in pairs(e) do
					e[a]=b*z
				end
			else
				img.shift[i]=e*z
			end
		end
	end
	img.scale=(img.scale or 1)*z img.y_scale=(img.y_scale or 1)*z img.x_scale=(img.x_scale or 1)*z
end

function Images.TintImages(pr,tint)
	local imgz=Images.FindImageLayers(pr)
	for k,v in pairs(imgz.images) do
		Images.MergeImageTable(v,{tint=table.deepcopy(tint)})
	end
end

function Images.MultiplyImages(pr,z)
	local imgz=Images.FindImageLayers(pr)
	for k,v in pairs(imgz.images)do Images.MultiplyImageSize(v,z) end
	for k,v in pairs(imgz.offsets)do Images.MultiplyOffsets(v,z) end
end

-- Function for tinting images for a recipe or an item
function Images.TintRecipeOrItem(itemOrRecipe, tint) 
	local newIcon = {
		icon = itemOrRecipe.icon,
		tint = tint,
		icon_size = itemOrRecipe.icon_size
	}
	itemOrRecipe.icons = {newIcon}
end