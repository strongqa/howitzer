# This module holds all custom howitzer exceptions
module Howitzer
  CommunicationError = Class.new(StandardError) #:nodoc:
  ParseError = Class.new(StandardError) #:nodoc:
  InvalidApiKeyError = Class.new(StandardError) #:nodoc:
  BadElementParamsError = Class.new(StandardError) #:nodoc:
  NoValidationError = Class.new(StandardError) #:nodoc:
  UnknownValidationError = Class.new(StandardError) #:nodoc:
  EmailNotFoundError = Class.new(StandardError) #:nodoc:
  NoAttachmentsError = Class.new(StandardError) #:nodoc:
  DriverNotSpecifiedError = Class.new(StandardError) #:nodoc:
  UnknownDriverError = Class.new(StandardError) #:nodoc:
  CloudBrowserNotSpecifiedError = Class.new(StandardError) #:nodoc:
  SelBrowserNotSpecifiedError = Class.new(StandardError) #:nodoc:
  UnknownBrowserError = Class.new(StandardError) #:nodoc:
  IncorrectPageError = Class.new(StandardError) #:nodoc:
  AmbiguousPageMatchingError = Class.new(StandardError) #:nodoc:
  NoMailAdapterError = Class.new(StandardError) #:nodoc:
  NoPathForPageError = Class.new(StandardError) #:nodoc:
  NoEmailSubjectError = Class.new(StandardError) #:nodoc:
  NoDataError = Class.new(StandardError) #:nodoc:
end
