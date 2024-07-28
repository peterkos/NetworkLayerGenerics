# NetworkLayerGenerics


An attempt to showcase the `TODO` I wrote for myself last night, while implementing a network stack for a SwiftUI app.

```swift
// TODO: unable to break out into separate `decode` function.
// Getting the error: `ResponseDTO<Response>.Type cannot conform to Codable`
let responseDTO: ResponseDTO<Response>
do {
    responseDTO = try JSONDecoder().decode(ResponseDTO<Response>.self, from: responseData)
} catch {
    return .failure(.jsonDecodingError(error.localizedDescription, request))
}

return .success(responseDTO.data)
```

### What happened?

I couldn't find the code I wrote when I _did_ factor out the above code to its own `static func` in AppNetwork. 

So, I tried re-creating it, and... suddenly had no problems. Of course.

### Why are there so many `Result` uses? Did you know that `throw` exists?

Don't worry, I want throw my Results out as well. But until typed throws ships in Swift 6, I'm wary of guessing how to handle errors with generic fallbacks. In this case it's probably fine... so uh, I'll refactor that at some point.

### There's a lot of generics too. Who hurt you?

Rust. Rust did.

### Are there other obtuse questions you have?

Oh! Yes. Thank you for reminding me.

The next one I'd like to figure out is how to convert a set of optional fields in type `T_DTO` to `T` as non-optional fields.

This is really easy _if_ you don't mind ignoring which field actually fails:

```swift

struct UserDTO: {
    var name: String?
    var password: String?
}

struct User: {
    var name: String
    var password: String

    func convert(from dto: UserDTO) -> Result<Self, DataError> {
        guard let name = dto.name,
              let password = dto.password
        } else {
            return .failure(.conversionError("Missing fields... somewhere. Who knows which."))
        }
        
        return User(name: name, password: password)
    }
}

```

My attempt at KeyPaths was foiled by my incompetency:

```swift

// ...

func convert(from dto: UserDTO) -> Result<Self, DataError> {
    func fix<T, V>(dto: T, value: KeyPath<T, V?>) -> Result<V, DataError> {
        if let value = dto[keyPath: value] {
            .success(value)
        } else {
            .failure(.invalidField(String(describing: dto)))
        }
    }
    let paths: PartialKeyPath<UserDTO.self> = [\.name, \.password]
    for path in paths {
        switch fix(dto, path) {
        case .success: // yay
        case .failure: // sad
    }
}
```

But, I am currently trying some magic with `@dynamicMemberLookup` to see if I can map key paths between the DTO and the type. :)


