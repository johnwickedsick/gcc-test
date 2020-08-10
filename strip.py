import os
API_KEY=os.environ.get("API_KEY", None)
GH_PERSONAL_TOKEN=API_KEY.split(" ")[0]:
with open('/tmp/GH_TOKEN','wb') as load:
    load.write(str.encode(GH_PERSONAL_TOKEN))
