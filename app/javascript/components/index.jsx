import React from "react";
import { createRoot } from "react-dom/client";
import App from "./App";
import './index.css';

document.addEventListener("turbo:load", () => {
  const div = document.createElement("div");
  div.classList.add("main"); // Add your CSS class here
  const root = createRoot(
    document.body.appendChild(div)
  );
  root.render(<App />);
});
