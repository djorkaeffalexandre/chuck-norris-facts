// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {

  internal enum Common {
    /// Ok
    internal static let ok = L10n.tr("Localizable", "Common.ok")
    /// Oops
    internal static let oops = L10n.tr("Localizable", "Common.oops")
  }

  internal enum EmptyView {
    /// Looks like there are no Facts
    internal static let empty = L10n.tr("Localizable", "EmptyView.empty")
    /// There are no facts to your search
    internal static let emptySearch = L10n.tr("Localizable", "EmptyView.emptySearch")
    /// Search
    internal static let search = L10n.tr("Localizable", "EmptyView.search")
  }

  internal enum Errors {
    /// Can't search facts
    internal static let cantSearchFacts = L10n.tr("Localizable", "Errors.cantSearchFacts")
    /// Can't sync categories
    internal static let cantSyncCategories = L10n.tr("Localizable", "Errors.cantSyncCategories")
  }

  internal enum FactCategory {
    /// UNCATEGORIZED
    internal static let uncategorized = L10n.tr("Localizable", "FactCategory.uncategorized")
  }

  internal enum FactsList {
    /// Chuck Norris Facts
    internal static let title = L10n.tr("Localizable", "FactsList.title")
  }

  internal enum SearchFacts {
    /// Search
    internal static let title = L10n.tr("Localizable", "SearchFacts.title")
    internal enum Sections {
      /// Past Searches
      internal static let pastSearches = L10n.tr("Localizable", "SearchFacts.sections.pastSearches")
      /// Suggestions
      internal static let suggestions = L10n.tr("Localizable", "SearchFacts.sections.suggestions")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
