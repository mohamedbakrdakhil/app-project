import { HTMLAttributes } from "react";

type CardProps = HTMLAttributes<HTMLDivElement>;

export default function Card({ children, className = "", style, ...props }: CardProps) {
  return (
    <div
      className={`rounded-2xl p-4 ${className}`}
      style={{ backgroundColor: "var(--bg-card)", border: "1px solid var(--border-soft)", boxShadow: "var(--shadow-card)", ...style }}
      {...props}
    >
      {children}
    </div>
  );
}
