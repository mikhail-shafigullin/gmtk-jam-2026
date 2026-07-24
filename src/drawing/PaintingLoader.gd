class_name PaintingLoader
extends Resource

const TEMP_FILE = "res://tmp/test_encode.webp"
const TEMP_PAINTINGS_DIR = "res://tmp/paintings"
const PADDING_SIZE = 256

static func serialize_painting(data: PaintingData) -> PackedByteArray:
	assert(data.texture, "no texture")
	
	var stats := data.serialize_stats()
	var img: Image = data.texture.get_image()

	var img_buff := img.save_webp_to_buffer()
	var stats_buff: PackedByteArray = []
	stats_buff.resize(PADDING_SIZE)
	stats_buff.encode_var(0, stats, false)

	var out: PackedByteArray = []
	img_buff.append_array(stats_buff)

	return img_buff

static func deserialize_painting(from: PackedByteArray) -> PaintingData:
	var data := PaintingData.new()

	var stats_pak := from.slice(from.size() - PADDING_SIZE)
	var stats_str: String = stats_pak.decode_var(0, false)
	data.deserialize_stats(stats_str)

	var img_pak := from.slice(0, from.size() - PADDING_SIZE)
	var img := Image.new()
	img.load_webp_from_buffer(img_pak)
	data.texture = ImageTexture.create_from_image(img)
	return data

static func write_temp_file_res(from: PaintingData) -> void:
	var t := ResourceSaver.save(from, "res://tmp/paintings/%s.tres"%Time.get_unix_time_from_system())
	print_debug(t)

static func write_temp_file(from: PackedByteArray) -> void:
	var f := FileAccess.open(TEMP_FILE, FileAccess.WRITE)
	f.store_buffer(from)
	f.close()

static func read_random_file_res() -> PaintingData:
	var files: Array[String] = []
	var dir := DirAccess.open(TEMP_PAINTINGS_DIR)

	if dir:
		dir.list_dir_begin()
		var fname: String = dir.get_next()
		while fname != "":
			if not dir.current_is_dir():
				files.push_back(fname)
			fname = dir.get_next()

	var data: PaintingData = ResourceLoader.load(TEMP_PAINTINGS_DIR + "/%s"%files.pick_random())
	return data

static func read_temp_file() -> PaintingData:
	var buff := FileAccess.get_file_as_bytes(TEMP_FILE)

	return deserialize_painting(buff)
	
