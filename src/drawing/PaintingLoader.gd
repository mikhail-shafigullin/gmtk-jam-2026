class_name PaintingLoader
extends Resource

const TEMP_FILE = "res://tmp/test_encode.webp"
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


static func write_temp_file(from: PackedByteArray) -> void:
	var f := FileAccess.open(TEMP_FILE, FileAccess.WRITE)
	f.store_buffer(from)
	f.close()

static func read_temp_file() -> PaintingData:
	var buff := FileAccess.get_file_as_bytes(TEMP_FILE)

	return deserialize_painting(buff)
	
