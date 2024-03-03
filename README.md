# flutter_snappyshop

## Compilar android

    flutter build apk --release

## Compilar ios

    flutter build ios --release

## cambiar el icono de la app

    flutter pub run flutter_launcher_icons

## Cambiar el splashscreen

    dart run flutter_native_splash:create

los cambios del splashscreen no se ven reflejados cuando se lanza la aplicacion desde el editor de codigo, hay que detener el editor y volver a correr, y abrirla presionando el icono en el celular


## Cambiar nombre de la app

    flutter pub run rename_app:main all="SnappyShop"

## Cambiar bundleId

    flutter pub run change_app_package_name:main com.joseperezgil.snappyshop
