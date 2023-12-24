import React from "react";
import styles from "./modules/Point.module.css";
import { PointData } from "./App";

const App: React.FC<{ data: PointData }> = ({ data }) => {
  let active = data.active;

  return (
    <div
      style={{
        ...data.pos,
        borderWidth: active ? "0.4rem" : "0.1rem",
        width: active ? "4rem" : "2rem",
        background: active ? "none" : "rgba(var(--primaryColor), 0.2)",
        fontSize: active ? "2.5rem" : "0.1rem",
        visibility: data.show ? 'visible' : 'hidden'
      }}
      className={styles.container}
    >
      {active ? (
        <>
          <div className={styles.ButtonLetter}>E</div>
          <div className={styles.pointText}>{data.text}</div>
        </>
      ) : (
        <div className={styles.dot}></div>
      )}
    </div>
  );
};

export default App;
