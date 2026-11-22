# 🍳 CookFresh – UI-Architektur (macOS-native)

Dieses Dokument beschreibt die vorgeschlagene Benutzeroberfläche für CookFresh im Stil nativer macOS-Apps (Systemeinstellungen, Finder, Mail).

---

## 1. Hauptfenster – 3-Spalten-Layout (NavigationSplitView)

```
┌─────────────┬──────────────────┬────────────────────────────┐
│  Sidebar    │   Content        │   Detail / Assistant       │
│  (Kategorien)│   (Liste)        │   (Chat + Kontext)         │
└─────────────┴──────────────────┴────────────────────────────┘
```

### Sidebar (links)
- Rezepte
- Wochenplan
- Einkaufsliste
- Chat / Assistent
- Einstellungen

Einklappbar (⌘\), Icons + Labels, `.listStyle(.sidebar)`.

### Content (Mitte)
- Rezept-Liste (Suche, Filter, Tags)
- Oder Wochenplan (Kalenderansicht)
- Oder Einkaufsliste (Checkboxen)

### Detail (rechts)
- Rezept-Detail (Zutaten, Schritte, Bild)
- Chat-Panel (einklappbar) für Fragen zum aktuellen Rezept

---

## 2. Rezept-Ansicht (Detail-Panel)

- **Hero-Bild** (groß, oben, `.scaledToFill()`)
- **Zutaten** (skalierbar nach Portionen)
- **Schritte** (nummeriert, Checkbox „erledigt“)
- **Timer-Buttons** („10 Min“ → startet native macOS-Timer)
- **Notizen / Anpassungen** (z. B. „Zucker -20%“)
- **Chat-Button** („Frage zum Rezept“ → öffnet Assistent mit Kontext)

---

## 3. Wochenplan (Kalender-View)

- 7-Tage-Raster (Mo–So)
- Drag & Drop Rezepte in Tage
- „Vorschlag generieren“ → KI schlägt Menü vor (nutzt Gedächtnis)
- Einkaufsliste automatisch aus Wochenplan ableiten

---

## 4. Einkaufsliste

- Gruppiert nach Kategorie (Gemüse, Milchprodukte, Gewürze…)
- Checkboxen zum Abhaken
- „Als erledigt markieren“ → entfernt aus Liste
- Export (Drucken, Teilen)

---

## 5. Assistent (Chat) – Kontextsensitiv

- **Kontext-Chip**: Zeigt aktuell geöffnetes Rezept („Du fragst zu: Lasagne“)
- **Schnellaktionen**: „Zutaten skalieren“, „Timer starten“, „Einkaufsliste erstellen“
- **Erinnerungen-Badges**: Wenn KI eine Regel angewendet hat, wird sie angezeigt

---

## 6. macOS-spezifische UI-Elemente

- **Toolbar**: Suche, Filter, Neu-Button (⌘N)
- **Sidebar**: Einklappbar (⌘\), Icons + Labels
- **Inspector** (rechte Sidebar): Zutaten, Nährwerte, Notizen
- **Sheets/Popovers**: Für Rezept bearbeiten, Timer, Einstellungen
- **Menu-Bar-Commands**: Datei → Neu, Bearbeiten → Suchen, etc.

---

## 7. Dark Mode & Akzentfarben

- System-Akzentfarbe (oder eigene)
- Rezept-Bilder mit `.scaledToFill()` und `clipShape`
- Material-Hintergründe (`.ultraThinMaterial`) für Panels

---

## 8. Tastatur-Shortcuts

| Shortcut | Aktion |
|---|---|
| ⌘N | Neues Rezept |
| ⌘F | Suche |
| ⌘\ | Sidebar ein/aus |
| ⌘K | Chat öffnen |
| ⌘, | Einstellungen |

---

## Nächste Schritte (Vorschlag)

1. **Rezept-Modell erweitern** (Zutaten, Schritte, Bilder, Tags)
2. **Rezept-Liste + Detail-View** implementieren
3. **Wochenplan** als Kalender-View
4. **Einkaufsliste** mit Aggregation

---

*Erstellt für CookFresh – native macOS Recipe Manager & Kitchen Assistant.*
