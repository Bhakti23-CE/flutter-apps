using System;
using System.Collections.Generic;
using Microsoft.Maui.Controls;

namespace WidgetDemoApp;

public partial class MainPage : ContentPage
{
    // Step 3: counter for the Like button, starting at zero
    private int likeCount = 0;

    // Step 5: collection of skill names used as the ItemsSource
    public List<string> Skills { get; set; }

    public MainPage()
    {
        InitializeComponent();

        Skills = new List<string>
        {
            "C#", ".NET", "MAUI", "XAML", "Git", "SQL", "Java", "Python"
        };

        // Lets {Binding Skills} in the XAML find the Skills property above
        BindingContext = this;
    }

    // Step 3: handler connected to LikeButton's Clicked event
    private void OnLikeClicked(object sender, EventArgs e)
    {
        likeCount++;
        LikeButton.Text = $"Like ({likeCount})";
    }

    // Step 4 (optional): shows a simple alert dialog
    private async void OnMessageClicked(object sender, EventArgs e)
    {
        await DisplayAlert("Message", "Message button tapped!", "OK");
    }
}