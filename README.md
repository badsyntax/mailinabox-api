# Mail-in-a-Box API

![Build & Publish](https://github.com/badsyntax/mailinabox-api/workflows/Build%20&%20Publish/badge.svg)

OpenAPI HTTP specification & client SDK's for the Mail-in-a-Box API.

Currently only shipping `typescript-fetch` but feel free to create an issue if you'd like a client SDK in a different language.

Note the specification is not complete and does not cover all endpoints, although I do plan on covering the entire API, stay tuned.

## Swagger editor

Use the swagger editor to explore the api:

https://editor.swagger.io/?url=https://raw.githubusercontent.com/badsyntax/mailinabox-api/master/schema/mailinabox.yml

## Clients

### `typescript-fetch`

https://www.npmjs.com/package/mailinabox-api

<details><summary>Template changes</summary>

## Supporting oneOf response types

The [Response Body](https://swagger.io/docs/specification/describing-responses/#body) spec says:

> The schema keyword is used to describe the response body. A schema can define:
>
> - a primitive data type such as a number or string – used for plain text responses

For endpoints that return a single primitive data type, the default generator will build the client so that it returns a `string` type _even if response type is set to `application/json`_. This seems to conform to the spec.

The mailinabox API returns primitive data types (eg `boolean`) for `application/json` responses, and we want that type represented in TypeScript. The follow changes were made to support both `application/json` and `text/html` endpoints that return a primitive data type.

```diff
--- a/templates/typescript-fetch/apis.mustache
+++ b/templates/typescript-fetch/apis.mustache
@@ -287,7 +287,9 @@ export class {{classname}} extends runtime.BaseAPI {
         return new runtime.JSONApiResponse<any>(response);
         {{/isListContainer}}
         {{#returnSimpleType}}
-        return new runtime.TextApiResponse(response) as any;
+        const contentType = response.headers.get('content-type');
+        const isJson = contentType && contentType.includes('application/json');
+        return new runtime[isJson ? 'JSONApiResponse' : 'TextApiResponse'](response) as any;
         {{/returnSimpleType}}
         {{/returnTypeIsPrimitive}}
         {{^returnTypeIsPrimitive}}
```

## Support posting text/(plain|html) bodies

Prevent quotes added to text/plain POST body. This seems like a bug in the generator, see https://github.com/OpenAPITools/openapi-generator/issues/7083.

```diff
--- a/templates/typescript-fetch/runtime.mustache
+++ b/templates/typescript-fetch/runtime.mustache
@@ -50,7 +50,7 @@ export class BaseAPI {
             // do not handle correctly sometimes.
             url += '?' + this.configuration.queryParamsStringify(context.query);
         }
-        const body = ((typeof FormData !== "undefined" && context.body instanceof FormData) || context.body instanceof URLSearchParams || isBlob(context.body))
+        const body = ((typeof FormData !== "undefined" && context.body instanceof FormData) || context.body instanceof URLSearchParams || isBlob(context.body)) || context.headers['Content-Type'] !== 'application/json'
            ? context.body
            : JSON.stringify(context.body);
```

</details>

## TODO

- [ ] Add missing endpoints
- [x] Add error responses
  - [x] 400 bad request
  - [x] 403 forbidden
  - [x] 5XX errors
- [x] Add response examples
- [ ] Add schema descriptions

## License

See [LICENSE.md](./LICENSE.md).
