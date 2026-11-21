# 🔄 CookFresh: KI-Gedächtnis-Lebenszyklus

Dieses Dokument beschreibt den Prozess einer Nutzeranfrage von der Eingabe bis zum automatischen "Lernen" neuer Fakten durch den `KitchenBrain`.

## 1. Anfrage-Phase (UI & Brain)
*   **Nutzer-Input:** Der Nutzer stellt eine Anfrage in `ChatView` (z. B. *"Ich möchte heute Käsespätzle, aber bitte keine schweren Nachtische mehr."*).
*   **Orchestrierung (`KitchenBrain`):**
    *   Empfängt den Prompt.
    *   **Context-Build:** Fragt `MemoryContextBuilder` an, um SwiftData-Daten (Allergien, Vorlieben, Historie) in einen kompakten System-Prompt zu übersetzen.
    *   **Entscheidung:** Router wählt die passende KI-Engine (Lokal vs. Cloud) basierend auf dem Prompt und der Verfügbarkeit.

## 2. KI-Generierung (Provider-Layer)
*   **Kontext-Übergabe:** Prompt + System-Kontext werden an den gewählten Provider (`GeminiProvider` oder `AppleFoundationProvider`) gesendet.
*   **Generierung:** Die KI generiert eine `MenuSuggestion` (Hauptgericht, Nachtisch, Begründung, angewendete Regeln).
*   **UI-Transparenz:** Die Antwort wird in `ChatView` angezeigt. Die `appliedMemories` werden dem Nutzer als kleine Badges präsentiert, damit er sieht: *"Ah, die KI hat meine Regel beachtet!"*

## 3. Automatisches Lernen (Im Hintergrund)
*   **Extraktion (`learnFromUserInput`):** Parallel zur Antwort-Generierung analysiert der `AppleFoundationProvider` die Nutzer-Eingabe auf neue Fakten (z.B. neue Tabus).
*   **Persistenz:** Neue Erkenntnisse werden als `MemoryEntry` in SwiftData gespeichert.
*   **UI-Feedback:** Der Nutzer erhält ein kurzes, nicht-intrusives Feedback:
    *   **`MemoryLearnedToast`** erscheint: *"🧠 Gemerkt: Keine schweren Sahne-Desserts"*.
    *   **Undo-Funktion:** Der Nutzer kann das Lernen per Klick sofort rückgängig machen.

## 4. Fortschritts-Übersicht

| Status | Komponente | Beschreibung |
| :--- | :--- | :--- |
| ✅ | **SwiftData** | `MemoryEntry` Modell ist definiert. |
| ✅ | **Context** | `MemoryContextBuilder` extrahiert SwiftData-Fakten. |
| 🛠 | **Brain** | `KitchenBrain` Orchestrator (in Arbeit). |
| 🛠 | **Interface** | `KitchenAIProvider` definiert das KI-Verhalten. |
| 🛠 | **UI** | `MemoryLearnedToast` & `MemoryManagementView`. |

## Flussdiagramm der Anfrage

```mermaid
sequenceDiagram
    participant User
    participant UI as ChatView
    participant Brain as KitchenBrain
    participant Builder as MemoryContextBuilder
    participant DB as SwiftData
    participant AI as Provider (Gemini/Apple)

    User->>UI: Prompt eingeben
    UI->>Brain: askAssistant(prompt)
    Brain->>Builder: buildContext(memories, recipes)
    Builder->>DB: Fetch MemoryEntries & Recipes
    DB-->>Builder: Daten liefern
    Builder-->>Brain: Kontext-String
    Brain->>AI: suggestMenu(prompt, context)
    AI-->>Brain: MenuSuggestion
    Brain-->>UI: MenuSuggestion anzeigen
    
    rect rgb(240, 230, 250)
        Note over Brain, DB: Hintergrund-Lernen
        Brain->>AI: executeTask(extractMemories)
        AI-->>Brain: Neue Fakten
        Brain->>DB: MemoryEntry speichern
        Brain-->>UI: Toast: "Gemerkt!"
    end
