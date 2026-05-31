"use client";
import { Component, type ReactNode } from "react";

interface Props {
  children: ReactNode;
  fallback?: ReactNode;
}

interface State {
  hasError: boolean;
  error: Error | null;
}

export default class ErrorBoundary extends Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = { hasError: false, error: null };
  }

  static getDerivedStateFromError(error: Error): State {
    return { hasError: true, error };
  }

  render() {
    if (this.state.hasError) {
      if (this.props.fallback) return this.props.fallback;
      return (
        <div className="p-6 rounded-2xl text-center space-y-3" style={{ backgroundColor: "rgba(255,85,85,0.08)", border: "1px solid rgba(255,85,85,0.2)" }}>
          <div className="text-3xl">⚠️</div>
          <p className="font-semibold" style={{ color: "var(--text-primary)" }}>Une erreur est survenue</p>
          <p className="text-sm" style={{ color: "var(--text-muted)" }}>{this.state.error?.message ?? "Erreur inconnue"}</p>
          <button
            onClick={() => this.setState({ hasError: false, error: null })}
            className="text-sm px-4 py-2 rounded-xl"
            style={{ backgroundColor: "var(--bg-card)", color: "var(--anatomy)", border: "1px solid var(--border-soft)" }}
          >
            Réessayer
          </button>
        </div>
      );
    }
    return this.props.children;
  }
}
