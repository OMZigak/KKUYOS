#!/bin/sh

# privacyInfo.plist 파일이 생성될 폴더 경로
FOLDER_PATH="/Volumes/workspace/repository/KkuMulKum"

# privacyInfo.plist 파일 이름
PLIST_FILENAME="privacyInfo.plist"

# privacyInfo.plist 파일의 전체 경로 계산
PLIST_FILE_PATH="$FOLDER_PATH/$PLIST_FILENAME"

# privacyInfo.plist 파일 생성
cat << EOF > "$PLIST_FILE_PATH"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>ServiceName</key>
    <string>$CI_APP_ID_PREFIX.KkuMulKum.yizihn</string>
    <key>BASE_URL_DEBUG</key>
    <string>$BASE_URL_DEBUG</string>
    <key>BASE_URL_RELEASE</key>
    <string>$BASE_URL_RELEASE</string>
    <key>NATIVE_APP_KEY</key>
    <string>$NATIVE_APP_KEY</string>
    <key>KeychainAccessGroups</key>
    <array>
        <string>$CI_APP_ID_PREFIX.KkuMulKum.yizihn</string>
    </array>
    <key>TEST_ACCESS_TOKEN</key>
    <string>$TEST_ACCESS_TOKEN</string>
</dict>
</plist>
EOF

echo "privacyInfo.plist 파일이 성공적으로 생성되었습니다."
cat "$PLIST_FILE_PATH"
