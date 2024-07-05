<p align="center"><a href="https://laravel.com" target="_blank"><img src="https://files.joseperezgil.com/images/snappyshop/logo.png" width="150" style="border-radius: 20px;" alt="Snappyshop Logo"></a></p>

# SnappyShop App Mobile

## Compilar android

    flutter build apk --release

## Compilar ios

    flutter build ios --release

## Cambiar icono de la app

    flutter pub run flutter_launcher_icons

## Cambiar splashscreen

```bash
dart run flutter_native_splash:create
```

los cambios del splashscreen no se ven reflejados cuando se lanza la aplicacion desde el editor de codigo, hay que detener el editor y volver a correr, y abrirla presionando el icono en el celular

## Cambiar nombre de la app

    flutter pub run rename_app:main all="SnappyShop"

## Cambiar bundle Id

    flutter pub run change_app_package_name:main com.joseperezgil.snappyshop

## Firebase

    flutterfire configure
