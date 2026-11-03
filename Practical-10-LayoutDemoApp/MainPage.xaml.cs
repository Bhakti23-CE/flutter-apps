namespace LayoutsDemoApp;

public partial class MainPage : ContentPage
{
    // Colours used when a category tag is selected / not selected
    private static readonly Color TagSelectedBackground = Color.FromArgb("#FF5722");
    private static readonly Color TagSelectedText = Colors.White;
    private static readonly Color TagNormalBackground = Color.FromArgb("#FFF0E8");
    private static readonly Color TagNormalText = Color.FromArgb("#BF360C");

    private ContentView? _selectedTag;       // the tag (Frame) currently selected
    private string _selectedCategory = "";   // text of the selected tag, e.g. "🍕 Pizza"
    private bool _isBusy;                    // true while the spinner is running

    public MainPage()
    {
        InitializeComponent();
    }

    //  Notification icon tapped (AbsoluteLayout) 
    private async void OnBellTapped(object? sender, TappedEventArgs e)
    {
        await DisplayAlertAsync(
            "Notifications",
            "You have 3 new notifications:\n" +
            "• Order #1042 is out for delivery\n" +
            "• 20% OFF coupon FOOD20 unlocked\n" +
            "• You earned 50 reward points",
            "OK");
    }

    //  Search button  
    private async void OnSearchRequested(object? sender, EventArgs e)
    {
        string query = SearchEntry.Text?.Trim() ?? "";

        if (query.Length == 0)
        {
            await DisplayAlertAsync("Search", "Please type a dish or restaurant name.", "OK");
            return;
        }

        await RunWithLoadingAsync($"Searching for \"{query}\"...",
                                  $"Showing results for \"{query}\"");
    }

    //  Category tag tapped (Frame inside the FlexLayout) 
    private void OnCategoryTapped(object? sender, TappedEventArgs e)
    {
        // Frame derives from ContentView, so this cast works for every tag
        if (sender is not ContentView tappedTag)
            return;

        // Un-highlight the previously selected tag
        if (_selectedTag is not null)
            SetTagAppearance(_selectedTag, false);

        // Tapping the same tag again clears the selection
        if (ReferenceEquals(_selectedTag, tappedTag))
        {
            _selectedTag = null;
            _selectedCategory = "";
            StatusLabel.Text = "No category selected";
            return;
        }

        // Highlight the new tag
        SetTagAppearance(tappedTag, true);
        _selectedTag = tappedTag;
        _selectedCategory = (tappedTag.Content as Label)?.Text ?? "";
        StatusLabel.Text = $"Selected: {_selectedCategory}";
    }

    //  "Order Now" button 
    private async void OnOrderNowClicked(object? sender, EventArgs e)
    {
        if (_isBusy)
            return;

        string what = _selectedCategory.Length > 0 ? _selectedCategory : "your favourites";

        await RunWithLoadingAsync("Placing your order...", "Order placed!");

        await DisplayAlertAsync(
            "Order Placed",
            $"Your order from {what} is on the way!\nEstimated delivery: 30 minutes.",
            "OK");
    }

    //  Helpers 

    // Shows the ActivityIndicator for ~1.5 seconds, then shows the finished message.
    private async Task RunWithLoadingAsync(string busyText, string doneText)
    {
        if (_isBusy)
            return;

        _isBusy = true;
        OrderNowButton.IsEnabled = false;
        LoadingIndicator.IsRunning = true;
        StatusLabel.Text = busyText;

        await Task.Delay(1500);   // pretend a network call is happening

        LoadingIndicator.IsRunning = false;
        StatusLabel.Text = doneText;
        OrderNowButton.IsEnabled = true;
        _isBusy = false;
    }

    // Switches a tag between "selected" and "normal" colours.
    private static void SetTagAppearance(ContentView tag, bool selected)
    {
        tag.BackgroundColor = selected ? TagSelectedBackground : TagNormalBackground;

        if (tag.Content is Label label)
            label.TextColor = selected ? TagSelectedText : TagNormalText;
    }
}