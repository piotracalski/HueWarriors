import { initializeApp } from "firebase/app";

const firebaseConfig = {
  apiKey: "AIzaSyAHg4uzJKPKYKO-j3ThvS7LucQbpTSg_F0",
  authDomain: "huewarriors.firebaseapp.com",
  projectId: "huewarriors",
  storageBucket: "huewarriors.appspot.com",
  messagingSenderId: "897347672307",
  appId: "1:897347672307:web:5b090f09627789bae6bf86"
};

export const firebase = initializeApp(firebaseConfig);