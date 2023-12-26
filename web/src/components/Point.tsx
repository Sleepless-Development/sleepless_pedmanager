import React from "react";
import styles from "./modules/Point.module.css";
import { PointData } from "./App";
import { MdOutlineHexagon, MdHexagon } from "react-icons/md";

const App: React.FC<{ data: PointData }> = ({ data }) => {
  let active = data.active;

  return (
    <div
      style={{
        ...data.pos,
        width: active ? "6rem" : "3rem",
        fontSize: active ? "2.5rem" : "0.1rem",
        visibility: data.show ? "visible" : "hidden",
      }}
      className={styles.container}
    >
      <MdOutlineHexagon
        style={{
          width: active ? "6rem" : "3rem",
          height: active ? "6rem" : "3rem",
        }}
        className={styles.hexagon}
      />
      <MdHexagon
        className={styles.hexagon}
        style={{
          width: active ? "6rem" : "3rem",
          height: active ? "6rem" : "3rem",
          fill: active ? "none" : "rgba(var(--primaryColor), 0.2)",
        }}
      />
      {active ? (
        <>
          <div className={styles.ButtonLetter}>E</div>
          <div className={styles.pointText}>{data.text}</div>
        </>
      ) : (
        <MdHexagon className={styles.dot} />
      )}
    </div>
  );
};

export default App;
