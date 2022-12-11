# adevices

`adevices` prints Apple platform devices information such as `ProductType` and `ProductDescription`. `ProductType` represents a model name like `iPhone14,3`. `ProductDescription` represents a product name like `iPhone 13 Pro Max`. 

## How to use

```sh 
# Execute without any options
$ adevices

# then
| ProductType   | ProductDescription                         |
|---------------|--------------------------------------------|
| MacFamily20,1 | Mac                                        |
| iPod9,1       | iPod touch (7th generation)                |
| iPod7,1       | iPod touch (6th generation)                |
| iPod5,1       | iPod touch                                 |
| iPhone11,4    | iPhone XS Max                              |
| iPhone11,6    | iPhone XS Max                              |
| iPhone11,2    | iPhone XS                                  |
| iPhone11,8    | iPhone XR                                  |
| iPhone10,3    | iPhone X                                   |
......
```

`adevices` prints all devices information from your active Xcode.app in Markdown Table format.

### Platforms

You can use these parameter with `--platform` option.

- iphone
- watch
- tv

Default options is all available platform.

### Formats

You can choose these formats bellow.

- csv
- tsv
- json
- markdown-table

`--enable-pretty-print` flag is enabled by default. You can use `--disable-pretty-print` when you prefer smaller output if the format supports.

### Path for Xcode or database

`adevices` searches database files from Xcode.app located at  `xcode-select --print-path`'s output path by default.

`adevices` provides two more options to select database files.

- `--database-path <database-path>`
    - Path to device_traits.db
- `--xcode-app-path <xcode-app-path>`
    - Path to Xcode.app

## Dependencies

`adevices` depends on Xcode.app you install.

## Completion Scripts

`adevices` supports generating completion scripts. See following documentation for details.

[Generating and Installing Completion Scripts | Documentation](https://apple.github.io/swift-argument-parser/documentation/argumentparser/installingcompletionscripts)
