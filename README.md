<img align="right" src="images/keyvalue-icon.png" width="120" height="120" alt="Two text inputs side-by-side with the values 'Key' and 'Value' on top of the Vokseværk 'fire-heart' logo" />

# Key/Value Editor for Umbraco

This property editor is *heavily* based on the **Multiple Textstrings** built-in
property editor, so should look and behave very similar to that one, even though
it has twice as many textboxes. (So hitting <kbd>Enter</kbd>/<kbd>Return</kbd>
adds another set, and you can sort them by using the handles on the right.)

It should work in Umbraco 7 as well as in Umbraco 8.

## Screenshots

### Property editor

**Blank editor**

![Editor Screen with blank fields](images/keyvalue-blank.jpg)

***

**With content**

![Editor Screen with 4 sets of keys and values](images/keyvalue-content.jpg)

### Configuration

![Config Screen](images/keyvalue-config.jpg)


## Using the editor

When creating a new DataType, choose `Key/Value Editor` as the property
editor.

As with **Multiple Textstrings** you can specify a minimum number of key/value 
sets, as well as a maximum.

## Rendering the output

The raw value is a JSON array with the keys and values, e.g.:

```json
[
  {
    "key": "Species",
    "value": "Tyrannosaurus Rex"
  },
  {
    "key": "Version",
    "value": "4.1"
  }
]
```

You can render it in a couple of different ways:

### 1. Using the Property Value Converter (preferred)

You can grab the appropriate *Property Value Converter* from the
[releases page](https://github.com/vokseverk/Vokseverk.KeyValueEditor/releases)
and add that to your solution (or put it directly into the `App_Code/` folder).

Then you can render the results like this using Models Builder
(assuming your property was named **Additional settings** with the
alias `additionalSettings`):

```razor
<dl>
  @foreach(var setting in Model.AdditionalSettings) {
    <dt>@(setting.Key)</dt>
    <dd>@(setting.Value)</dd>
  }
</dl>
```

### 2. Without the Property Value Converter

If you can't use the converter, you can use the following way of accessing the
keys and values:

```razor
<dl>
  @foreach(var setting in Model.AdditionalSettings) {
    <dt>@(setting["key"])</dt>
    <dd>@(setting["value"])</dd>
  }
</dl>
```
