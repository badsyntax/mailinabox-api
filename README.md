# mailinabox-api

## Template changes

### typescript-fetch

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
