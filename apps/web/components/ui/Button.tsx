import { ButtonHTMLAttributes } from "react";

type Variant = "primary" | "secondary" | "ghost";

interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: Variant;
  loading?: boolean;
}

export default function Button({ variant = "primary", loading, children, className = "", ...props }: ButtonProps) {
  const base = "px-4 py-3 rounded-xl font-semibold text-sm transition-all disabled:opacity-50 disabled:cursor-not-allowed";
  const variants: Record<Variant, string> = {
    primary: "text-white",
    secondary: "border",
    ghost: "text-sm",
  };
  const styles: Record<Variant, React.CSSProperties> = {
    primary: { backgroundColor: "var(--anatomy)", color: "white" },
    secondary: { borderColor: "var(--border-soft)", color: "var(--text-primary)", backgroundColor: "var(--bg-card)" },
    ghost: { color: "var(--text-secondary)", backgroundColor: "transparent" },
  };
  return (
    <button
      className={`${base} ${variants[variant]} ${className}`}
      style={styles[variant]}
      disabled={loading ?? props.disabled}
      aria-busy={loading ?? undefined}
      {...props}
    >
      {loading ? "..." : children}
    </button>
  );
}
