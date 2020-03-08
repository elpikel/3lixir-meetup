def encode(data):
    encoded_data = ""
    for data_item in data:
        encoded_data += "%^^^%" + str(data_item) + "%^^^%"
    return encoded_data