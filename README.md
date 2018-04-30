Dates and times independent of time zone.

#### Warning!

You probably don't need this! It should be very rare to need to a date independent of time zone. When in doubt, just use Apple's `Date` type.

#### What do you mean by "independent of time zone"?

Apple's `Date` type is independent of time zone, but it represents a specific _point in time_. By contrast, an `AbsoluteDate` represents not a specific point in time, but a "floating" date such as "2018-01-20 18:30:33". The actual point in time represented by "2018-01-20 18:30:33" depends upon which time zone it's in.

#### Why on Earth would I need this?

Most of the time you should not need this. But there are rare cases where it can be useful. It is particularly useful when using `AbsoluteDay`, which represents a day independent of time and time zone.

Imagine an application that tracks various activities a user performs. This user is a globetrotter and is frequently in different time zones. These activities are merged together at the end of the day to produce an "activity score". But which day do we use? Moving across time zones, particularly in the middle of the night, can produce changes in which day it is. In this case, we'll use the day as the user perceives it, the `AbsoluteDay`. By passing a `Date` and `TimeZone` to the initializer of `AbsoluteDay`, we strip out those considerations and just use an abstract "day", which we then use to perform our activity score calculation.

#### Why not just use a string?

You could. But the types contained in this framework offer some conveniences over a string. For instance, given a variable `d` of type `AbsoluteDay`, we can say `d + 1` to get the next `AbsoluteDay`. You can also use the `date` property or the `date` function to convert back to a `Date` very easily.

#### Serialization

All of the types contained herein serialize using Apple's `Codable`. While they always encode to a `String`, they can decode from a `Date` or `String`. How a `Date` decodes is dependent upon the `dateDecodingStrategy` property of the `Decoder`. Once the `Date` is decoded, the `AbsoluteDate` is derived by formatting it in the current time zone. To use a different time zone, set the `CodingUserInfoKey.absoluteDateTimeZone` key of the decoder's `userInfo` property to your preferred time zone, e.g.,

```swift
let decoder = JSONDecoder()
decoder.userInfo[.absoluteDateTimeZone] = TimeZone(identifier: "UTC")!
let absoluteDate = try decoder.decode(AbsoluteDate.self, from: jsonData)
```

