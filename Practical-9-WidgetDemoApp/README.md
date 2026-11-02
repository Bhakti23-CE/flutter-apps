# Experiment 9: Develop Xamarin Applications Consisting of Widgets

## Application Name
**WidgetDemoApp – Student Profile Card**

## Aim
To develop a cross-platform mobile application using common UI widgets and run it on an Android emulator.

## Description
This application is a Student Profile Card developed using **.NET MAUI, C#, and XAML**. It demonstrates different UI controls, layouts, event handling, and data binding.

## Components Used
- ContentPage
- ScrollView
- VerticalStackLayout
- HorizontalStackLayout
- Border
- Image
- Frame
- Label
- Button
- Entry
- CollectionView

## Features
- Displays a student profile picture placeholder.
- Shows student name and course details.
- Like button with an interactive counter.
- Message button that displays an alert dialog.
- Comment input field.
- Horizontally scrollable skills list.

## Technologies Used
- C#
- XAML
- .NET MAUI
- Visual Studio 2026
- Android Emulator (Pixel 7, API 36)

## Project Structure
```text
WidgetDemoApp/
│
├── MainPage.xaml
├── MainPage.xaml.cs
├── App.xaml
├── AppShell.xaml
├── MauiProgram.cs
├── Platforms/
└── Resources/
```

## How to Run
1. Open the project in Visual Studio.
2. Restore the NuGet packages.
3. Start the Pixel 7 Android emulator.
4. Select the emulator as the deployment target.
5. Press F5 to build and run the application.

## Output
The application runs successfully on the Pixel 7 Android emulator.
- The Like button counter increases when tapped.
- The Message button displays an alert dialog.
- The comment field accepts text input.
- The skills list scrolls horizontally.

## Conclusion
Successfully developed and executed a Student Profile Card application using .NET MAUI. The experiment demonstrates different UI widgets, layouts, event handling, and data binding in cross-platform mobile application development.

### Note: Xamarin.Forms was replaced with .NET MAUI because Xamarin.Forms is no longer supported and its project template was unavailable in the installed Visual Studio.
