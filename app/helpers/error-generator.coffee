# error-generator.coffee
# Generate errors to pass to error-handling middleware using next()

class HTTPError
  constructor: (status = 500, message = 'Unknown Error') ->
    err = Error.call(this, message)
    err.name = 'HTTP Error'
    err.status = status
    return err

class NotFound extends HTTPError
  constructor: (status = 404, message = 'Page Not Found') ->
    return super(status, message)

class Forbidden extends HTTPError
  constructor: (status = 403, message = 'Forbidden') ->
    return super(status, message)

class Unauthorized extends HTTPError
  constructor: (status = 401, message = 'Unauthorized') ->
    return super(status, message)

class BadRequest extends HTTPError
  constructor: (status = 400, message = 'Forbidden') ->
    return super(status, message)

class ServiceUnavailable extends HTTPError
  constructor: (status = 503, message = 'Service Unavailable') ->
    return super(status, message)

class NotImplemented extends HTTPError
  constructor: (status = 501, message = 'Not Implemented') ->
    return super(status, message)

class InternalServerError extends HTTPError
  constructor: (status = 500, message = 'Internal Server Error') ->
    return super(status, message)

module.exports =
  HTTPError: HTTPError
  NotFound: NotFound
  Forbidden: Forbidden
  Unauthorized: Unauthorized
  BadRequest: BadRequest
  ServiceUnavailable: ServiceUnavailable
  NotImplemented: NotImplemented
  InternalServerError: InternalServerError
