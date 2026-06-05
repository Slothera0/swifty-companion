include .env
export

run:
	flutter run \
		--dart-define=API_UID=$(API_UID) \
		--dart-define=API_SECRET=$(API_SECRET)

build:
	flutter build apk --release \
		--dart-define=API_UID=$(API_UID) \
		--dart-define=API_SECRET=$(API_SECRET)

install:
	adb install build/app/outputs/flutter-apk/app-release.apk

release: build install