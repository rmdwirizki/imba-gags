# Imba-gags

Like 9gag but much simpler. Made with Imba, Sass and Firebase.

## Installation

```
npm install
```

### Firebase Setting

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

## Development

```
npm run dev
```

## Build

```
npm install -g imba
imba src/server.imba
```

## Todo

- [ ] Class model abstraction

- [x] Home page
- [x] Create/Update page
- [x] Comment 
- [ ] Like

- [x] Firebase data storage
- [x] Login and authentication
- [ ] Style and CSS

- [ ] Pagination