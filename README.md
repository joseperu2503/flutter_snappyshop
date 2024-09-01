<p align="center">
<img src="assets/images/logo.png" width="150"  alt="logo">
</p>

# SnappyShop App

## Compilar android

```bash
flutter build apk --release
```

## Compilar ios

```bash
flutter build ios --release
```

## Cambiar icono de la app

```bash
flutter pub run flutter_launcher_icons
```

## Cambiar splashscreen

```bash
dart run flutter_native_splash:create
```

los cambios del splashscreen no se ven reflejados cuando se lanza la aplicacion desde el editor de codigo, hay que detener el editor y volver a correr, y abrirla presionando el icono en el celular

## Cambiar nombre de la app

```bash
flutter pub run rename_app:main all="SnappyShop"
```

## Cambiar bundle Id

```bash
flutter pub run change_app_package_name:main com.joseperezgil.snappyshop
```

## Firebase

```bash
flutterfire configure
```
