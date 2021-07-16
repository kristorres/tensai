import SwiftUI

/// A simple representation of a color in the sRGB color space.
///
/// The `red`, `green`, and `blue` component values should be from `0` to `1`,
/// inclusively.
typealias SRGBColor = (red: Double, green: Double, blue: Double)

/// Returns a lightened version of an sRGB color.
///
/// - Parameter srgbColor: The sRGB color to lighten.
/// - Parameter factor:    The lightening factor.
///
/// - Returns: The lightened sRGB color.
func lighten(_ srgbColor: SRGBColor, by factor: Double) -> SRGBColor {
    let red = lighten(srgbColor.red, by: factor)
    let green = lighten(srgbColor.green, by: factor)
    let blue = lighten(srgbColor.blue, by: factor)
    return (red, green, blue)
}

/// Returns the relative luminance of the specified sRGB color.
///
/// The formula used in the implementation of this function can be found
/// [here](https://www.w3.org/TR/WCAG20/#relativeluminancedef).
///
/// - Parameter srgbColor: The sRGB color.
///
/// - Returns: The relative luminance.
func relativeLuminance(of srgbColor: SRGBColor) -> Double {
    let R = convertToLinearRGB(srgbColor.red)
    let G = convertToLinearRGB(srgbColor.green)
    let B = convertToLinearRGB(srgbColor.blue)
    return R * 0.2126 + G * 0.7152 + B * 0.0722
}

/// Converts the specified sRGB color component value to its linear RGB
/// equivalent.
///
/// The conversion formula used in this function can be found
/// [here](https://www.w3.org/TR/WCAG20/#relativeluminancedef).
///
/// - Parameter srgbColorComponent: The sRGB color component value to convert.
///                                 It should be from `0` to `1`, inclusively.
///
/// - Returns: The linear RGB color component value.
fileprivate func convertToLinearRGB(_ srgbColorComponent: Double) -> Double {
    if srgbColorComponent > 0.03928 {
        return pow((srgbColorComponent + 0.055) / 1.055, 2.4)
    }
    return srgbColorComponent / 12.92
}

/// Returns a “lightened” version of an sRGB color component value.
///
/// - Parameter srgbColorComponent: The sRGB color component value to “lighten.”
///                                 It should be from `0` to `1`, inclusively.
/// - Parameter factor:             The lightening factor.
///
/// - Returns: The “lightened” sRGB color component value.
fileprivate func lighten(
    _ srgbColorComponent: Double,
    by factor: Double
) -> Double {
    return srgbColorComponent + (1 - srgbColorComponent) * factor
}

extension Color {
    
    /// Creates a constant color from the specified `SRGBColor` value.
    ///
    /// - Parameter srgbColor: An `SRGBColor` value from which to create the
    ///                        color.
    init(srgbColor: SRGBColor) {
        self.init(
            red: srgbColor.red,
            green: srgbColor.green,
            blue: srgbColor.blue
        )
    }
}
