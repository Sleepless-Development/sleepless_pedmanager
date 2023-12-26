import React, { useEffect, useState } from "react";
import { debugData } from "../utils/debugData";
import Point from "./Point";
import { useNuiEvent } from "../hooks/useNuiEvent";

debugData([
  {
    action: "setVisible",
    data: true,
  },
]);

debugData([
  {
    action: "textUIs",
    data: {
      [123123]: {
        pos: { left: "50%", top: "50%" },
        text: "Hello World Hello Woorld",
        show: true,
        active: true,
      },
    },
  },
]);

export interface PointData {
  pos: { left: string; top: string };
  text: string;
  show: boolean;
  active: boolean;
}

const App: React.FC = () => {
  const [points, setPoints] = useState<{ [index: number]: PointData }>({});
  const [pause, setPause] = useState<boolean>(false)

  useNuiEvent<{ [index: number]: PointData }>("textUIs", (newPoints) => {
    if (!newPoints) return;
    setPoints((prevState) => ({
      ...prevState,
      ...newPoints,
    }));
  });

  useNuiEvent<boolean>("pause", (paused) => {
    setPause(paused)
  });

  return (
    <>
      {(Object.keys(points).length > 0 && !pause) ? (
        Object.keys(points).map((index) => {
          let value = points[parseInt(index)];
          return <Point key={index} data={value} />;
        })
      ) : (
        <></>
      )}
    </>
  );
};

export default App;
