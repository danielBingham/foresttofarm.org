# Fonts

Forest to Farm uses several custom fonts that need some level of specific
maintenace.  This documents those fonts and the maintenance required.

## Google Fonts

Forest to Farm uses two fonts from the Google Font Api to compose its logo in
the header.  The two fonts are "Arima Maduri", used for the "Forest" part of
the logo, and "Cabin Sketch", used for the "Farm" part of the logo.

To include these two fonts, it is necessary to include the linked stylesheet
provided by google.  The relevent link line can be found 
in  ``app/views/layouts/master.blade.php``:

```
    <link href="https://fonts.googleapis.com/css?family=Arima+Madurai|Cabin+Sketch" rel="stylesheet">
```

Direct links to the font api:
- [Arima Madurai](https://fonts.google.com/specimen/Arima+Madurai)
- [Cabin Sketch](https://fonts.google.com/specimen/Cabin+Sketch)

## Icomoon Icon Font

Forest to Farm uses the Icomoon app to generate a glif icon font from a
selection of svg icons.  Using an icon font allows us to manipulate the icons
using CSS more easily, since we can style them as we would any font.  That
means styling with fill color, size, text decoration, drop shadow, etc.

### Adding Icons to the Icomoon Font

1. Go to ``icomoon.io/app/``
2. If selection isn't cached in your browser, you can reupload it.  
    1. Click on "untitled project" to go to the project page.  
    2. Click on "import project"
    3. Select navigate to your repo directory and then select ``fonts/selection.json``
    4. Click import
3. Once the selection is imported you can select new icons to add to it or upload external icons (in svg form) to add to it.
4. When you're done adding icons to the selection, click Generate Font.
5. Click download to download a new ``icomoon.zip``.
6. Navigate to the ``fonts`` directory and delete everything in it.
7. Move the ``icomoon.zip`` file you just downloaded to the ``fonts`` directory and unzip it.  
8. You can delete everything except for the ``font`` directory, ``selection.json`` andicomoon.zip.
9. Delete the contents of ``public/fonts``
10. Move the contents of the ``font`` directory to ``public/fonts/``
11. Rename the font files to ``ftf-icons``.  So ``icomoon.eot`` should become ``ftf-icons.eot``.  Do this for each font file type (``.ttf``, ``.svg``, and  ``.woff``).
12. Make a new class for each of your new icons.  
    1. On the generate page you'll find a glyph number for each icon you added.  For example, the glyph for the "Home" icon is ``e900``.  
    2. For each icon you added, create a class at the top of ``forest.css`` following this pattern (where you replace ``e900`` with your glyph number).

```css
.icon-name:before {
    content: "\e900";
}
```
    3. Save forest.css and you're done!  Font file sucessfully updated.  You can use the new class on a blank element (usually ``<span></span>`` or ``<a></a>``) to use your icon.

