# Imba-gags

Like 9gag but much simpler. Made with Imba, Sass and Firebase.
It's made to practice a workflow of realtime applications.

## Installation

```
npm install
```

### Firebase Setting

#### Account

- Create file `src/Config.imba` 
- Copy the content from `src/Config.example.imba`
- Fill the firebase credentials

```js
export var firebaseConf = {
  apiKey: "xxx",
  authDomain: "xxx.firebaseapp.com",
  databaseURL: "https://xxx.firebaseio.com",
  projectId: "xxx",
  storageBucket: "xxx.appspot.com",
  messagingSenderId: "xxx"
}
```

#### Cloud Functions Trigger

Get firebase-tools to depoy cloud functions via CLI.

```
npm install -g firebase-tools
```

In your working directory, run the following commands.

```
firebase init functions
```

Setup your `.firebaserc` file with your firebase `projectId`.
Cloud functions are store in `functions/index.js`.

Then deploy the functions to make it live in the firebase server.

```
firebase deploy --only functions
```

## Development

```
npm run dev
```

## Build

Don't forget to install imba CLI first

```
npm install -g imba
imba src/server.imba
```

To run a build version while in development, open another terminal and run

```
npm run build
```

## Todo

- [ ] Class model abstraction

- [x] Home page
- [x] Create/Update page
- [x] Comment 
- [ ] Like / Fun / Vote

- [x] Firebase data storage
- [x] Login and authentication
- [x] Style and CSS
- [ ] Responsive CSS

- [ ] Pagination
- [ ] Optimizing Assets
- [x] Deploy demo applications -> See [https://labs.develoka.com/imba-gags/](https://labs.develoka.com/imba-gags/)
