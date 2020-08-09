import * as Parse from 'parse/node'

Parse.Cloud.define("testcloud", async (request) => {
    console.log("Got called!");
    return {
        "success": true,
        "bananas": "yellow"
    };
});