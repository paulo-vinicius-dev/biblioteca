!#/bin/sh

cd back\
go get
go build &&
mv biblioteca build\ &&
.\build\biblioteca &&

cd .. &
cd front\biblioteca &
flutter run

